job "cyberchef" {
  datacenters = ["*"]
  
  type = "service"

  group "cyberchef" {
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
      name = "cyberchef"
      port = "http"
      provider = "consul"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.cyberchef.rule=Host(`cyberchef.securitybits.io`)",
        "traefik.http.routers.cyberchef.entrypoints=websecure",
        "traefik.http.routers.cyberchef.tls.certresolver=letsencrypt",
        "traefik.http.routers.whoami-secure.middlewares=authelia@consulcatalog"

      ]

      check {
        name     = "alive"
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "cyberchef" {
      driver = "docker"
      config {
        image = "mpepping/cyberchef"
        ports = ["http"]
      }
    }
  }
}