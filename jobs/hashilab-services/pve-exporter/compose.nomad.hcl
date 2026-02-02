job "pve-exporter" {
  datacenters = ["*"]
  type        = "service"

  group "monitoring" {
    count = 1

    network {
      port "http" {
        static = 9221
      }
    }
    
    service {
      name = "pve-exporter"
      port = "http"
      
      check {
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "pve-exporter" {
      driver = "docker"

      config {
        image = "prompve/prometheus-pve-exporter:${IMAGE_TAG}"
        ports = ["http"]
        args  = [
            "--config.file", "local/pve.yml",
            "--no-collector.config",
            "--no-collector.status"
          ]
      }

      template {
        data = <<EOH
          {{ with nomadVar "nomad/jobs/pve-exporter/env" }}
          IMAGE_TAG={{ .IMAGE_TAG }}
          {{ end }}
        EOH
        destination = "local/.env"
        env         = true  
      }

      template {
        data = <<EOH
        {{ with nomadVar "nomad/jobs/pve-exporter/secrets" }}
default:
  user: "telegraf@pve"
  token_name: "monitoring"
  token_value: "{{ .MONITORING_TOKEN }}"
  verify_ssl: false
        {{ end }}
EOH
        destination = "local/pve.yml"
      }

      resources {
        cpu    = 100 # MHz
        memory = 64  # MB
      }

    }
  }
}