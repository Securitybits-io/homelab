job "template" {
  datacenters = ["*"]
  
  type = "service"

  group "template" {
    constraint {
      attribute = "${attr.unique.hostname}"
      operator  = "="
      value     = "nomad-02"
    }

    network {
      port "http" {
        to = 9091
      }
    }

    service {
      name = "template"
      port = "http"
      provider = "consul"

      check {
        name     = "alive"
        type     = "tcp"
        port     = "http"
        path     = "/template/web"
        interval = "10s"
        timeout  = "2s"
        #expose   = true
      }

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.template.rule=Host(`template.securitybits.io`)",
        "traefik.http.routers.template.entrypoints=websecure",
        "traefik.http.routers.template.tls.certresolver=letsencrypt",
        "traefik.http.routers.template.middlewares=ip-whitelist@file"
      ]

      canary_tags = [
        "traefik.enable=false",
      ]
    }

    update {
      max_parallel = 0
      health_check = "checks"
      auto_revert  = true
    }

    task "template" {
      driver = "docker"
      config {
        image = "hello-world"
        ports = [ "http" ]
        cap_add = [ "NET_ADMIN" ]
        # volumes = [
        #   "local/:/local"
        # ]

        # mount {
        #   target = "/config"
        #   source = "template-mount"

        #   volume_options {
        #     no_copy = "false"
        #     driver_config  {
        #       name = "local"
        #       options {
        #         type = "cifs"
        #         device = "//10.0.11.241/template/config"
        #         o = "rw,vers=3.0,dir_mode=0777,file_mode=0777,username=guest,password=\"\""
        #       }
        #     }
        #   }
        # }
      }

      env {
        TZ      = "Europe/Stockholm"
      }

      # template {
      #   data = <<EOH
      #   {{- with nomadVar "nomad/jobs/template/secrets" }}
      #   USERNAME={{ .USER }}
      #   {{- end }}
      #   EOH
      #   destination = "secrets/creds.env"
      #   change_mode = "noop"
      #   env = true
      # }

      resources {
        cpu    = 100
        memory = 300
      }

      restart {
        interval = "12h"
        attempts = 720
        delay    = "60s"
        mode     = "delay"
      }

      kill_timeout = "20s"
    }
  }
}