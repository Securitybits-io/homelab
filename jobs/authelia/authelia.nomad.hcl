job "authelia" {
  #region = "global"
  datacenters =  ["*"]
  type = "service"

  group "authelia" {
    count = 1

    constraint {
      attribute = "${meta.node_roles}"
      value     = "web"
      operator  = "set_contains_any"
    }

    network {
      port "authelia" {
        to = 9091
        static = 9091
      }
    }

    service {
      name = "authelia"
      port = "authelia"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.authelia.rule=Host(`auth.securitybits.io`)",
        "traefik.http.routers.authelia.tls.certResolver=letsencrypt",
        "traefik.http.middlewares.authelia.forwardAuth.address=http://${NOMAD_IP_authelia}:${NOMAD_PORT_authelia}/api/authz/forward-auth",
        "traefik.http.middlewares.authelia.forwardAuth.trustForwardHeader=true",
        "traefik.http.middlewares.authelia.forwardAuth.authResponseHeaders=Remote-User,Remote-Groups,Remote-Name,Remote-Email"
      ]

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

      config {
        image = "authelia/authelia:latest"
        ports = ["authelia"]
        # mount {
        #   target = "/authelia"
        #   source = "authelia"
        #   volume_options {
        #     no_copy = "false"
        #     driver_config  {
        #       name = "local"
        #       options {
        #         type = "cifs"
        #         device = "//10.0.11.241/Securitybits.Systems/Authelia"
        #         o = "vers=3.0,dir_mode=0777,file_mode=0777,username=guest,password=\"\""
        #       }
        #     }
        #   }
        # }
      }

      env {
        TZ    = "Europe/Stockholm"
        X_AUTHELIA_CONFIG = "/local/"
        AUTHELIA_JWT_SECRET_FILE             = "/local/jwt.secret"
        AUTHELIA_SESSION_SECRET_FILE         = "/local/session.secret"
        AUTHELIA_STORAGE_ENCRYPTION_KEY_FILE = "/local/storage.secret"
      }

      template {
        data        = file("./config.yml")
        destination = "local/configuration.yml"
        change_mode = "restart"
      }

      template {
        data        = <<EOH
        users:
          christoffer:
            {{ with nomadVar "nomad/jobs/authelia/users/christoffer" -}}
            disabled: false
            displayname: 'Christoffer Claesson'
            password: '{{ .PASSWORD }}'
            email: '{{ .EMAIL }}'
            groups:
              - 'admins'
              - 'users'
            {{ end -}}
        EOH
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