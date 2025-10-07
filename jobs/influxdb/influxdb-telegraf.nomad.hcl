job "influxdb-telegraf" {
  datacenters = ["*"]
  type        = "service"

  group "influxdb" {
    count = 1

    constraint {
      attribute = "${meta.node_roles}"
      value     = "management"
      operator  = "set_contains_any"
    }

    network {
      port "http" {
        static = 8086
      }
    }

    service {
      name     = "influxdb-telegraf"
      port     = "http"
      provider = "consul"

      check {
        type     = "http"
        path     = "/ping"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "influxdb-telegraf" {
      driver = "docker"

      config {
        image = "influxdb:1.8"
        ports = ["http"]
        
        mount {
          type = "bind"
          target = "/var/lib/influxdb"
          source = "/docker/data/InfluxDB/Telegraf"
          readonly = false
        }
      }

      template {
        data        = <<EOH
        {{ with nomadVar "nomad/jobs/influxdb-telegraf/secrets" }}
          DOCKER_INFLUXDB_HTTP_AUTH_ENABLED="true"
          DOCKER_INFLUXDB_DB="{{ .bucket }}"
          DOCKER_INFLUXDB_ADMIN_USER="{{ .admin_user }}"
          DOCKER_INFLUXDB_ADMIN_PASSWORD="{{ .admin_password }}"
          DOCKER_INFLUXDB_USER="{{ .telegraf_user }}"
          DOCKER_INFLUXDB_USER_PASSWORD="{{ .telegraf_password }}"
        {{ end }}
        EOH
        destination = "secrets/file.env"
        env         = true
      }

      resources {
        cpu    = 500  # 500 MHz
        memory = 1024 # 1 GB
      }
    }
  }
}
