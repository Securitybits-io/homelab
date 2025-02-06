job "authelia" {
  #region = "global"
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

    ephemeral_disk {
      migrate = true
      size    = 300
      sticky  = true
    }

    task "authelia" {
      driver = "docker"

      env {
        TZ    = "Europe/Stockholm"
        X_AUTHELIA_CONFIG = "/local/"
        AUTHELIA_JWT_SECRET_FILE             = "/local/jwt.secret"
        AUTHELIA_SESSION_SECRET_FILE         = "/local/session.secret"
        AUTHELIA_STORAGE_ENCRYPTION_KEY_FILE = "/local/storage.secret"
      }

      config {
        image = "authelia/authelia:latest"
        ports = ["authelia"]
      }

      template {
        data        = file("./config.yml")
        destination = "local/configuration.yml"
        change_mode = "restart"
      }

      template {
        data        = file("./users.yml")
        destination = "local/users/users.yml"
        change_mode = "restart"
      }
      
      template {
        data    = <<EOH
        {{ with nomadVar "nomad/jobs/authelia/secrets" }}{{ .JWT_SECRET }}{{ end -}}
        EOH
        destination = "local/jwt.secret"
      }

      template {
        data    = <<EOH
        {{ with nomadVar "nomad/jobs/authelia/secrets" }}{{ .STORAGE_SECRET }}{{ end -}}
        EOH
        destination = "local/storage.secret"
      }

      template {
        data    = <<EOH
        {{ with nomadVar "nomad/jobs/authelia/secrets" }}{{ .SESSION_SECRET }}{{ end -}}
        EOH
        destination = "local/session.secret"
      }
    }
  }
}