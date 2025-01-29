job "spiderfoot" {
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
        to = 5001
      }
    }

    service {
      name = "spiderfoot-service"
      port = "http"
      provider = "consul"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.microbin-router.rule=Host(`spiderfoot.securitybits.io`)",
        "traefik.http.routers.microbin-router.entrypoints=websecure",
        "traefik.http.routers.microbin-router.tls.certresolver=letsencrypt",
        "traefik.http.routers.traefik-dashboard-router.middlewares=ip-whitelist@file",
      ]

      check {
        name     = "alive"
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "server" {
      driver = "docker"
      config {
        image = "ctdc/spiderfoot"
        ports = ["http"]
      }
    }
  }
}