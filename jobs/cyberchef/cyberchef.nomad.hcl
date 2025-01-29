job "cyberchef" {
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
        to = 8000
      }
    }

    service {
      name = "cyberchef-service"
      port = "http"
      provider = "consul"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.microbin-router.rule=Host(`cyberchef.securitybits.io`)",
        "traefik.http.routers.microbin-router.entrypoints=websecure",
        "traefik.http.routers.microbin-router.tls.certresolver=letsencrypt",
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
        image = "mpepping/cyberchef"
        ports = ["http"]
      }
    }
  }
}