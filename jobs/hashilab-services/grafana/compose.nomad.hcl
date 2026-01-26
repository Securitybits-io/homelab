job "grafana" {
  datacenters = ["*"]
  type        = "service"

  group "grafana" {
    count = 1

    constraint {
      attribute = "${meta.node_roles}"
      value     = "management"
      operator  = "set_contains_any"
    }

    network {
      port "http" {
        static = 3000
      }
    }

    service {
      name     = "grafana"
      port     = "http"
      provider = "consul"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.grafana.rule=Host(`grafana.securitybits.io`)",
        "traefik.http.routers.grafana.entrypoints=websecure",
        "traefik.http.routers.grafana.tls.certresolver=letsencrypt",
        "traefik.http.routers.grafana.middlewares=ip-whitelist@file",
      ]

      check {
        type     = "http"
        path     = "/api/health"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "grafana" {
      driver = "docker"

      config {
        image = "grafana/grafana:${IMAGE_TAG}"
        ports = ["http"]
        image_pull_timeout = "15m"


        mount {
          type   = "volume"
          target = "/var/lib/grafana"
          source = "grafana-data"
        }
        
        volumes = [
          "local/provisioning:/etc/grafana/provisioning",
        ]
      }

      template {
        data = <<EOH
        {{ with nomadVar "nomad/jobs/grafana/env" }}
          IMAGE_TAG={{ .IMAGE_TAG }}
        {{ end }}
        EOH
        destination = "local/.env"
        env         = true
      }

      # This template fetches secrets and sets Grafana's main configuration
      template {
        data = <<EOH
        {{ with nomadVar "nomad/jobs/grafana/secrets" }}
          GF_SECURITY_ADMIN_USER={{ .admin_user }}
          GF_SECURITY_ADMIN_PASSWORD={{ .admin_password }}
        {{ end }}
          GF_SERVER_ROOT_URL=https://grafana.securitybits.io
          GF_SERVER_HTTP_PORT=${NOMAD_PORT_http}
          GF_USERS_ALLOW_SIGN_UP=false
          GF_AUTH_ANONYMOUS_ENABLED=true
          GF_AUTH_ANONYMOUS_ORG_ROLE=Viewer
          GF_PLUGINS_PREINSTALL=grafana-worldmap-panel,grafana-piechart-panel,yesoreyeram-boomtable-panel,snuids-radar-panel,grafana-polystat-panel
        EOH
        destination = "secrets/file.env"
        env         = true
      }

      template {
        destination = "local/provisioning/datasources/influxdb.yml"
        data = <<EOF
          apiVersion: 1
          datasources:
            - name: InfluxDB - Telegraf
              type: influxdb
              access: proxy
              url: http://{{ range service "influxdb-telegraf" }}{{ .Address }}:{{ .Port }}{{ end }}
              {{ with nomadVar "nomad/jobs/influxdb-telegraf/secrets" }}
              database: "{{ .bucket }}"
              user: "{{ .admin_user }}"
              secureJsonData:
                password: "{{ .admin_password }}"
              {{ end }}
          EOF
      }

      # This template automatically provisions the Loki data source
      template {
        destination = "local/provisioning/datasources/loki.yml"
        data = <<EOF
          apiVersion: 1
          datasources:
            - name: Loki
              type: loki
              access: proxy
              url: http://{{ range service "loki" }}{{ .Address }}:{{ .Port }}{{ end }}
          EOF
      }

      resources {
        cpu    = 500  # 500 MHz
        memory = 512 # 512 MB
      }
    }
  }
}