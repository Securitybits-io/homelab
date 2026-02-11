job "telegraf" {
  datacenters = ["*"]
  type = "service"

  group "telegraf" {
    update {
      max_parallel = 1
      auto_revert  = true
    }

    task "telegraf" {
      driver = "docker"

      config {
        image = "telegraf:${IMAGE_TAG}"
        image_pull_timeout = "10m"

        volumes = [
          "local/telegraf.conf:/etc/telegraf/telegraf.conf:ro",
        ]

        cap_add = ["SYS_ADMIN"]
        mount {
          type   = "bind"
          source = "/var/run/docker.sock"
          target = "/var/run/docker.sock"
        }
      }

      template {
        data = <<EOH
          IMAGE_TAG="{{ with nomadVar "nomad/jobs/telegraf/env" }}{{ .IMAGE_TAG }}{{ end }}"
        EOH

        destination = "local/.env"
        change_mode = "restart"
        env         = true
      }

      template {
        data = <<EOH
        {{ with nomadVar "nomad/jobs/telegraf/secrets" }}
          TELEGRAF_OPENWEATHER_TOKEN="{{ .TELEGRAF_OPENWEATHER_TOKEN }}"
        {{ end }}
        EOH

        destination = "secrets/.env"
        change_mode = "restart"
        env         = true
      }

      template {
        destination = "local/telegraf.conf"
        #change_mode = "restart"
        change_mode = "signal"
  			change_signal = "SIGHUP"
        wait {
          min = "15s"
          max = "2m"
        }

        data = <<EOF
          # Global Agent Configuration
          [agent]
            interval = "10s"
            round_interval = true
            metric_batch_size = 1000
            metric_buffer_limit = 10000
            collection_jitter = "0s"
            flush_interval = "10s"
            flush_jitter = "0s"
            precision = ""
            hostname = "{{ env "attr.unique.hostname" }}"
            omit_hostname = false

          # == OUTPUTS ==
          [[outputs.influxdb]]
            # Discover the InfluxDB service registered in Consul
            urls = ["http://{{ range service "influxdb-telegraf" }}{{ .Address }}:{{ .Port }}{{ end }}"]
            
          {{ with nomadVar "nomad/jobs/influxdb-telegraf/secrets" }}
            database = "{{ .bucket }}"
            username = "{{ .telegraf_user }}"
            password = "{{ .telegraf_password }}"
          {{ end }}

          # == INPUTS ==
          [[inputs.ping]]
            urls = [ "www.securitybits.io" ]
            interval = "60s"
            count = 4
            ping_interval = 1.0
            timeout = 1.0
            deadline = 10

            [inputs.ping.tags]
              geohash="u660ug94"
          
          [[inputs.internet_speed]]
            interval = "10m"

          # [[inputs.openweathermap]]
          #     app_id = "${TELEGRAF_OPENWEATHER_TOKEN}"
          #     city_id =[
          #       "2702979"        # Jonkoping
          #       # "2673730",        # Stockholm
          #       # "2711537",        # Gothenburg
          #       # "2720501",        # Boras
          #       # "2690170",        # Nassjo
          #       # "2677234"         # Skovde
          #     ]
          #     fetch = [
          #         "weather",
          #         "forecast"
          #     ]
          #     units = "metric"
          #     interval = "10m"
        EOF
      }

      resources {
        cpu    = 200 # 200 MHz
        memory = 256 # 256 MB
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
