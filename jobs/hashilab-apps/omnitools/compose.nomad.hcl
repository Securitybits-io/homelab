job "omnitools" {
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
        to = 80
      }
    }

    service {
      name = "omnitools"
      port = "http"
      provider = "consul"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.omnitools.rule=Host(`omnitools.securitybits.io`)",
        "traefik.http.routers.omnitools.entrypoints=websecure",
        "traefik.http.routers.omnitools.tls.certresolver=letsencrypt"

      ]

      check {
        name     = "alive"
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "omnitools" {
      driver = "docker"
      config {
        image = "iib0011/omni-tools:${IMAGE_TAG}"
        ports = ["http"]
      }

      template {
        data = <<EOH
        {{ with nomadVar "nomad/jobs/omnitools/env" }}
          IMAGE_TAG="{{ .IMAGE_TAG }}"
        {{ end }}
        EOH

        destination = "local/.env"
        env         = true
      }
    }
  }
}