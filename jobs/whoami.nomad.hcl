job "whoami" {
  datacenters = ["*"]
  
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