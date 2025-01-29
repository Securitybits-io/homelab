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
        "traefik.http.routers.microbin-router.rule=PathPrefix(`microbin.securitybits.io`)",
        "traefik.http.routers.microbin-router.entrypoints=websecure",
        "traefik.http.routers.microbin-router.tls.certresolver=letsencrypt",
      ]
    }

    task "server" {
      driver = "docker"
      env {
        MICROBIN_PUBLIC_PATH = "/microbin"
      }
      config {
        image = "danielszabo99/microbin"
        ports = ["http"]
      }
    }
  }
}