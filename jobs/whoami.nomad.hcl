job "whoami" {
  datacenters = ["*"]
  affinity {
    attribute = "${meta.node_class}"
    operator  = "="
    value     = "ingress"
    #weight    = "50" # The higher the weight, the stronger the preference
  }

  type = "service"

  group "demo" {
    count = 3

    network {
       port "http" {
         to = 80
       }
    }

    service {
      name = "whoami-demo"
      port = "http"
      provider = "consul"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.whoami-router.rule=Path(`/whoami`)",
      ]
    }

    task "server" {
      env {
        WHOAMI_PORT_NUMBER = "${NOMAD_PORT_http}"
      }

      driver = "docker"

      config {
        image = "traefik/whoami"
        ports = ["http"]
      }
    }
  }
}