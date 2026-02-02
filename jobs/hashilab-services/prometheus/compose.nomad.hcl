job "prometheus" {
  datacenters = ["*"]
  type        = "service"

  group "prometheus" {
    count = 1

    network {
      port "http" {
        static = 9090
      }
    }

    volume "prometheus-data" {
      type            = "csi"
      source          = "prometheus-data"
      access_mode     = "multi-node-multi-writer"
      attachment_mode = "file-system"
    }
    
    service {
      name = "prometheus"
      port = "http"
      tags = ["monitoring", "prometheus"]
      
      check {
        type     = "http"
        path     = "/-/healthy"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "prometheus" {
      driver = "docker"

      config {
        image = "prom/prometheus:v${IMAGE_TAG}"
        ports = ["http"]
        args = [
          "--config.file=/local/prometheus.yml",
          "--storage.tsdb.path=/prometheus",
          "--web.enable-lifecycle" # Allows reloading config via HTTP POST
        ]
      }
      
      env {
        TZ = "Europe/Stockholm"
      }

      volume_mount {
        volume        = "prometheus-data"
        destination   = "/prometheus"
        read_only     = false
      }

      template {
        data = <<EOH
          IMAGE_TAG="{{ with nomadVar "nomad/jobs/prometheus/env" }}{{ .IMAGE_TAG }}{{ end }}"
        EOH

        destination = "local/.env"
        change_mode = "restart"
        env         = true
      }

      # DYNAMIC CONFIGURATION
      template {
        change_mode = "signal"
        change_signal = "SIGHUP"
        destination = "local/prometheus.yml"
        data = <<EOH
global:
  scrape_interval: 10s

scrape_configs:
  # 1. NOMAD METRICS (Nodes & Allocations)
  - job_name: 'nomad-metrics'
    metrics_path: '/v1/metrics'
    params:
      format: ['prometheus']
    consul_sd_configs:
      - server: 'consul:8500'
        services: ['nomad', 'nomad-client']
    relabel_configs:
      - source_labels: ['__meta_consul_node']
        target_label: 'hostname'
      - source_labels: ['__meta_consul_tags']
        regex: '(.*)http(.*)'
        action: keep

  # 2. CONSUL METRICS
  - job_name: 'consul-metrics'
    metrics_path: '/v1/agent/metrics'
    params:
      format: ['prometheus']
    consul_sd_configs:
      - server: 'consul:8500'
        services: ['consul']
    relabel_configs:
      - source_labels: ['__meta_consul_node']
        target_label: 'hostname'
      # This replaces the RPC port (8300) with the HTTP port (8500)
      - source_labels: ['__address__']
        regex: '(.*):8300'
        target_label: '__address__'
        replacement: '$1:8500'

  # # 3. ENVOY / SERVICE MESH METRICS
  # # This finds any service in the mesh with the tag 'prometheus'
  # - job_name: 'nomad-service-mesh'
  #   consul_sd_configs:
  #     - server: 'consul:8500'
  #   relabel_configs:
  #     - source_labels: ['__meta_consul_tags']
  #       regex: '.*prometheus.*'
  #       action: keep
  #     - source_labels: ['__address__', '__meta_consul_service_metadata_envoy_metrics_port']
  #       separator: ';'
  #       regex: '(.*):(.*);(.*)'
  #       replacement: '$1:3'
  #       target_label: '__address__'

  - job_name: 'pve-node-01'
    metrics_path: /pve
    scrape_interval: 30s
    scrape_timeout: 25s
    consul_sd_configs:
      - server: 'consul:8500'
        services: ['pve-exporter']
    relabel_configs:
      - target_label: __param_target
        replacement: 'pve-node-01' 
      - target_label: instance
        replacement: 'pve-node-01'
EOH
      }

      resources {
        cpu    = 500
        memory = 1024
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