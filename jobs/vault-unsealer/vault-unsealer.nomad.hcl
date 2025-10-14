job "vault-unsealer" {
  # Run this in the same datacenter as Vault
  datacenters = ["dc"]
  # Use "system" to run on all nodes, or "service" to run a specific number
  type = "service"

  # Run this job on a management node, or wherever is appropriate
  constraint {
    attribute = "${meta.node_roles}"
    value     = "management"
    operator  = "set_contains_any"
  }

  group "unsealer" {
    count = 1

    # Restart the job if it fails, with a delay.
    # This is useful if Vault isn't ready when the job first starts.
    restart {
      attempts = 5
      delay    = "30s"
      interval = "5m"
      mode     = "delay"
    }

    # This task runs first to download the Bitwarden CLI
    task "bws-installer" {
      driver = "docker"
      config {
        image = "alpine:3.18"
        command = "local/install.sh"
      }

      # The lifecycle hook ensures this runs before the main "unseal" task
      lifecycle {
        hook    = "prestart"
        sidecar = false
      }

      # Download and unzip the bws CLI into the shared /alloc/data directory
      template {
        data = <<EOH
#!/bin/sh
set -e
apk add --no-cache curl unzip
BWS_VERSION="0.4.0"
curl -L "https://github.com/bitwarden/secrets-manager-cli/releases/download/v${BWS_VERSION}/bws-linux-amd64-${BWS_VERSION}.zip" -o /alloc/data/bws.zip
unzip /alloc/data/bws.zip -d /alloc/data
chmod +x /alloc/data/bws
echo "Bitwarden CLI installed."
EOH
        destination = "local/install.sh"
        perms       = "744"
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }

    task "unseal" {
      driver = "docker"

      # Use the official vault image, which has the vault CLI
      config {
        image = "hashicorp/vault:latest"
        # The command is our templated script
        command = "local/unseal.sh"
      }

      # Inject the Bitwarden Access Token from Nomad variables
      env {
        VAULT_ADDR = "http://vault.service.consul:8200" # Or your Vault IP/DNS
      }

      # This is the core logic
      template {
        data = <<EOH
#!/bin/sh
set -e

# Wait for Vault to be available
until /usr/local/bin/vault status -address="${VAULT_ADDR}"; do
  echo "Waiting for Vault to become available..."
  sleep 5
done

# Check if Vault is sealed
if /usr/local/bin/vault status -address="${VAULT_ADDR}" | grep -q "Sealed.*true"; then
  echo "Vault is sealed. Proceeding with unseal."
  export BWS_ACCESS_TOKEN="{{ with secret "nomad/jobs/vault-unsealer" }}{{ .Data.bws_access_token }}{{ end }}"
  
  # Fetch and apply each key from Bitwarden Secrets Manager
  /alloc/data/bws secret get a1b2c3d4-1234-5678-90ab-cdef12345678 | jq -r .value | xargs /usr/local/bin/vault operator unseal -address="${VAULT_ADDR}"
  /alloc/data/bws secret get e5f6g7h8-1234-5678-90ab-cdef12345678 | jq -r .value | xargs /usr/local/bin/vault operator unseal -address="${VAULT_ADDR}"
  /alloc/data/bws secret get i9j0k1l2-1234-5678-90ab-cdef12345678 | jq -r .value | xargs /usr/local/bin/vault operator unseal -address="${VAULT_ADDR}"
  
  echo "Vault unseal process completed."
else
  echo "Vault is already unsealed."
fi
EOH
        destination = "local/unseal.sh"
        perms       = "744"
      }

      resources {
        cpu    = 200
        memory = 128
      }
    }
  }
}
