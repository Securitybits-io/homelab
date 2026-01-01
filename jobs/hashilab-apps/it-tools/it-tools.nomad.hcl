job "it-tools" {
  datacenters = ["*"]
  
  type = "service"

  group "it-tools" {
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
      name = "it-tools"
      port = "http"
      provider = "consul"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.it-tools.rule=Host(`it-tools.securitybits.io`)",
        "traefik.http.routers.it-tools.entrypoints=websecure",
        "traefik.http.routers.it-tools.tls.certresolver=letsencrypt",
        "traefik.http.routers.it-tools.middlewares=authelia@consulcatalog"
      ]

      check {
        name     = "alive"
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "it-tools" {
      driver = "docker"
      config {
        image = "corentinth/it-tools:${IMAGE_TAG}"
        ports = ["http"]
      }

      template {
        data = <<EOH
        {{ with nomadVar "nomad/jobs/it-tools/env" }}
          IMAGE_TAG="{{ .IMAGE_TAG }}"
        {{ end }}
        EOH

        destination = "local/.env"
        env         = true
      }
    }
  }
}