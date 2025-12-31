job "loki" {
  datacenters = ["*"]
  type        = "service"

  group "loki" {
    count = 1

    constraint {
      attribute = "${meta.node_roles}"
      value     = "management"
      operator  = "set_contains_any"
    }

    network {
      port "http" {
        static = 3100
      }
    }

    service {
      name     = "loki"
      port     = "http"
      provider = "consul"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.loki.rule=Host(`loki.securitybits.io`)",
        "traefik.http.routers.loki.entrypoints=websecure",
        "traefik.http.routers.loki.tls.certresolver=letsencrypt",
        "traefik.http.routers.loki.middlewares=ip-whitelist@file",
      ]

      check {
        type     = "http"
        path     = "/ready"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "loki" {
      driver = "docker"

      config {
        image = "grafana/loki:${IMAGE_TAG}"
        ports = ["http"]
        args = [
          "-config.file=/local/loki-config.yml",
        ]

        # Mount a persistent volume for Loki's data (indexes and chunks)
        mount {
          type   = "volume"
          target = "/loki"
          source = "loki-data"
        }
      }
      template {
        data = <<EOH
          IMAGE_TAG="{{ with nomadVar "nomad/jobs/loki" }}{{ .version }}{{ end }}"
        EOH

        destination = "local/run.env"
        env         = true
        change_mode = "signal"
        change_signal = "SIGHUP"
      }
      # This template generates the Loki configuration file inside the allocation.
      template {
        destination = "local/loki-config.yml"
        change_mode = "restart"

        data = <<EOF
auth_enabled: false

server:
  http_listen_port: {{ env "NOMAD_PORT_http" }}

common:
  path_prefix: /loki
  storage:
    filesystem:
      chunks_directory: /loki/chunks
      rules_directory: /loki/rules
  replication_factor: 1
  ring:
    kvstore:
      store: inmemory

schema_config:
  configs:
    - from: 2020-10-24
      store: boltdb-shipper
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h

compactor:
  working_directory: /loki/compactor
  compaction_interval: 24h
  retention_enabled: true
  retention_delete_worker_count: 20
  retention_delete_delay: 1h
  delete_request_store: filesystem
  
limits_config:
  retention_period: 30d
  
# ruler:
#   alertmanager_url: http://localhost:9093
          EOF
      }

      resources {
        cpu    = 500  # 500 MHz
        memory = 1024 # 1 GB
      }

      restart {
        interval = "12h"
        attempts = 720
        delay    = "60s"
        mode     = "delay"
      }

      kill_timeout = "20s"
    }
  }
}
