job "whoami" {
  datacenters = ["*"]
  
  type = "service"

  group "demo" {
    count = 20

    # constraint {
    #   attribute = "${meta.node_roles}"
    #   value     = "web"
    #   operator  = "set_contains_any"
    # }

    network {
       port "http" {
         to = 80
       }
    }

    service {
      name = "whoami-demo"
      port = "http"
      provider = "consul"

      # tags = [
      #   "traefik.enable=true",
      #   "traefik.http.routers.whoami-router.rule=Host(`whoami.securitybits.io`)",
      #   "traefik.http.routers.whoami-router.entrypoints=websecure",
      #   "traefik.http.routers.whoami-router.entrypoints=websecure",
      #   "traefik.http.routers.whoami-router.tls.certresolver=letsencrypt",
      #   "traefik.http.routers.whoami-router.middlewares=ip-whitelist@file",
      # ]
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