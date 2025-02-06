job "authelia" {
  region = "global"
  datacenters =  ["*"]
  type = "service"

  group "authelia" {
    count = 1

    network {
      port "authelia" {
        to = 9091
        static = 9091
      }
    }

    service {
      name = "authelia"
      port = "authelia"

      # tags = [
      #   "traefik.enable=true",
      #   "traefik.http.routers.authelia.rule=Host(`auth.securitybits.io`)",
      #   "traefik.http.routers.authelia.tls.certResolver=letsencrypt",
      # ]

      check {
        name     = "alive"
        type     = "tcp"
        port     = "authelia"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "authelia" {
      driver = "docker"

      env {
        TZ    = "Europe/Stockholm"
        AUTHELIA_JWT_SECRET_FILE      = "CHANGEME"
        AUTHELIA_SESSION_SECRET_FILE  = "CHANGEME"
      }

      config {
        image = "authelia/authelia:latest"
        ports = ["authelia"]
      }
    }
  }
}