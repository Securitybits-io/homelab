job "telegraf" {
  datacenters = ["*"]
  type = "system"

  group "telegraf" {
    network {
      mode = "host"
    }

    update {
      max_parallel = 1
      auto_revert  = true
    }

    task "telegraf" {
      driver = "docker"

      config {
        image = "telegraf:1.29"

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
          # CPU metrics
          [[inputs.cpu]]
            percpu = true
            totalcpu = true
            collect_cpu_time = false
            report_active = false

          # System memory metrics
          [[inputs.mem]]

          # Disk I/O metrics
          [[inputs.diskio]]

          # Docker container metrics
          [[inputs.docker]]
            endpoint = "unix:///var/run/docker.sock"
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
