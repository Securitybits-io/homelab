job "microbin" {
  datacenters = ["*"]
  
  type = "service"

  group "microbin" {
    constraint {
      attribute = "${meta.node_roles}"
      value     = "web"
      operator  = "set_contains_any"
    }

    network {
      port "http" {
        to = 8080
      }
    }

    service {
      name = "microbin-service"
      port = "http"
      provider = "consul"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.whoami-router.rule=Path(`/microbin`)",
        "traefik.http.services.microbin.loadbalancer.server.port=8080",
        "traefik.http.middlewares.microbin-strip-prefix.stripPrefix.prefixes=/microbin",
      ]
    }

    task "server" {
      driver = "docker"

      config {
        image = "danielszabo99/microbin"
        ports = ["http"]
      }
    }
  }
}