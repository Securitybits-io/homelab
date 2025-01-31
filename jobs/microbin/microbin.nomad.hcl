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
      name = "microbin"
      port = "http"
      provider = "consul"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.microbin.rule=Host(`microbin.securitybits.io`)",
        "traefik.http.routers.microbin.entrypoints=websecure",
        "traefik.http.routers.microbin.tls.certresolver=letsencrypt",
      ]

      check {
        name     = "alive"
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "microbin" {
      driver = "docker"
      config {
        image = "danielszabo99/microbin"
        ports = ["http"]
      }
    }
  }
}