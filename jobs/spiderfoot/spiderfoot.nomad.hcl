job "spiderfoot" {
  datacenters = ["*"]
  
  type = "service"

  group "spiderfoot" {
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
      name = "spiderfoot"
      port = "http"
      provider = "consul"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.spiderfoot.rule=Host(`spiderfoot.securitybits.io`)",
        "traefik.http.routers.spiderfoot.entrypoints=websecure",
        "traefik.http.routers.spiderfoot.tls.certresolver=letsencrypt",
        "traefik.http.routers.spiderfoot.middlewares=ip-whitelist@file",
      ]

      check {
        name     = "alive"
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "spiderfoot" {
      driver = "docker"
      config {
        image = "ctdc/spiderfoot"
        ports = ["http"]
      }
    }
  }
}