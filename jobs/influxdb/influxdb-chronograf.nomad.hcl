job "influxdb-chronograf" {
  datacenters = ["*"]
  type        = "service"

  group "chronograf" {
    count = 1

    constraint {
      attribute = "${meta.node_roles}"
      value     = "management"
      operator  = "set_contains_any"
    }

    network {
      mode = "host"
      port "http" {
        static = 8888
      }
    }

    service {
      name     = "influxdb-chronograf"
      port     = "http"
      provider = "consul"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.chronograf.rule=Host(`chronograf.securitybits.io`)",
        "traefik.http.routers.chronograf.entrypoints=websecure",
        "traefik.http.routers.chronograf.tls.certresolver=letsencrypt",
        "traefik.http.routers.chronograf.middlewares=ip-whitelist@file",
      ]

      check {
        type     = "http"
        path     = "/ping"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "chronograf" {
      driver = "docker"

      config {
        image = "chronograf:1.10"
        ports = ["http"]

        # Use a Docker-managed volume for Chronograf's own data (dashboards, etc.)
        mount {
          type   = "volume"
          target = "/var/lib/chronograf"
          source = "chronograf-data"
        }
      }

      # This template configures Chronograf by creating an environment file.
      # It discovers the InfluxDB service and fetches the admin password securely.
      template {
        data = <<EOH
          INFLUXDB_URL=http://{{ range service "influxdb-telegraf" }}{{ .Address }}:{{ .Port }}{{ end }}
          INFLUXDB_USERNAME=admin
          INFLUXDB_PASSWORD={{ with nomadVar "nomad/jobs/influxdb-telegraf" }}{{ .admin_password }}{{ end }}
        EOH

        destination = "secrets/file.env"
        env         = true
      }

      resources {
        cpu    = 200  # 200 MHz
        memory = 256 # 256 MB
      }
    }
  }
}
