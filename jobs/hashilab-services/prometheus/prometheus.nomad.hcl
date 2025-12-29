# https://grafana.com/docs/alloy/latest/tutorials/send-metrics-to-prometheus/
job "prometheus" {
  datacenters = ["*"]
  type        = "service"

  group "prometheus" {
    count = 1

    constraint {
      attribute = "${meta.node_roles}"
      value     = "management"
      operator  = "set_contains_any"
    }

    network {
      port "http" {
        static = 9090
      }
    }

    service {
      name     = "prometheus"
      port     = "http"
      provider = "consul"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.prometheus.rule=Host(`prometheus.securitybits.io`)",
        "traefik.http.routers.prometheus.entrypoints=websecure",
        "traefik.http.routers.prometheus.tls.certresolver=letsencrypt",
        "traefik.http.routers.prometheus.middlewares=ip-whitelist@file",
      ]

      check {
        type     = "http"
        path     = "/-/ready" # Prometheus ready endpoint
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "prometheus" {
      driver = "docker"

      env {
        # Set Consul HTTP address for Prometheus to use for service discovery.
        # Assumes a Consul agent is running on the same host as Prometheus at the default port 8500.
        CONSUL_HTTP_ADDR = "127.0.0.1:8500"
      }

      config {
        image = "prom/prometheus:v2.49.1" # Using a specific stable version
        ports = ["http"]
        args = [
          "--config.file=/local/prometheus.yml",
          "--storage.tsdb.path=/prometheus",
          "--web.enable-lifecycle", # Allows reloading config via HTTP POST to /-/reload
        ]

        mount {
          type   = "volume"
          target = "/prometheus"
          source = "prometheus-data"
        }
      }

      template {
        destination = "local/prometheus.yml"
        change_mode = "restart"

        data = <<EOF
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node_exporter'
    consul_sd_configs:
      - server: "{{ env "CONSUL_HTTP_ADDR" }}" # Use the env var set in the task
        services: ['node-exporter'] # Assumes node_exporter registers itself with Consul
    relabel_configs:
      - source_labels: ['__meta_consul_node']
        target_label: 'instance'

  - job_name: 'cadvisor'
    consul_sd_configs:
      - server: "{{ env "CONSUL_HTTP_ADDR" }}"
        services: ['cadvisor'] # Assumes cAdvisor registers itself with Consul
    relabel_configs:
      - source_labels: ['__meta_consul_node']
        target_label: 'instance'

  - job_name: 'consul'
    static_configs:
      - targets: ['localhost:8500'] # Consul agent metrics endpoint

  - job_name: 'nomad'
    static_configs:
      - targets: ['localhost:4646'] # Nomad agent metrics endpoint

  - job_name: 'consul-discovered-services'
    consul_sd_configs:
      - server: "{{ env "CONSUL_HTTP_ADDR" }}"
    relabel_configs:
      # Keep services that have 'traefik.enable=true' or 'prometheus.scrape=true' tags
      - source_labels: ['__meta_consul_tags']
        regex: '.*traefik.enable=true.*|.*prometheus.scrape=true.*'
        action: keep
      # Set the job label to the Consul service name
      - source_labels: ['__meta_consul_service']
        target_label: 'job'
      # Set the instance label to the Consul node name
      - source_labels: ['__meta_consul_node']
        target_label: 'instance'
      # Construct the target address from Consul's address and port
      - source_labels: ['__meta_consul_address', '__meta_consul_port']
        regex: '(.+);(.+)'
        target_label: '__address__'
        replacement: '$1:$2'
      # Optional: Extract metrics path from a tag if available (e.g., 'prometheus.path=/metrics')
      - source_labels: ['__meta_consul_tags']
        regex: '.*prometheus.path=(.+)'
        target_label: '__metrics_path__'
        replacement: '$1'
        action: replace
      # Optional: Extract scheme from a tag if available (e.g., 'prometheus.scheme=https')
      - source_labels: ['__meta_consul_tags']
        regex: '.*prometheus.scheme=(.+)'
        target_label: '__scheme__'
        replacement: '$1'
        action: replace

EOF
      }

      resources {
        cpu    = 1000 # 1 CPU core
        memory = 2048 # 2 GB
      }

      restart {
        interval = "12h"
        attempts = 720
        delay    = "15s"
        mode     = "delay"
      }

      kill_timeout = "30s" # Give Prometheus time to gracefully shut down and write data
    }
  }
}
