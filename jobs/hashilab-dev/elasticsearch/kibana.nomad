job "kibana" {
  datacenters = ["dc"]

  constraint {
    attribute = "${meta.node_roles}"
    operator  = "=="
    value     = "dev"
  }

  group "kibana" {
    network {
      mode = "bridge"
      port "http" { to = 5601 }
    }

    service {
      name = "kibana"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.kibana.rule=Host(`kibana.securitybits.io`)",
        "traefik.http.routers.kibana.entrypoints=websecure",
        "traefik.http.routers.kibana.tls.certresolver=letsencrypt",
        "traefik.http.routers.kibana.middlewares=ip-whitelist@file",
      ]

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "es-data"
              local_bind_port  = 9200
            }
          }
        }
      }
    }

    task "kibana" {
      driver = "docker"
      config {
        image = "elastic/kibana:9.4.0"
      }
      env {
        ELASTICSEARCH_HOSTS = "http://127.0.0.1:9200"
        I18N_LOCALE         = "en"
      }
    }
  }
}