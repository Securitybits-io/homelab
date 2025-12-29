# https://github.com/plexguide/Huntarr.io

job "huntarr" {
  datacenters = ["*"]
  
  type = "service"

  group "huntarr" {
    constraint {
      attribute = "${attr.unique.hostname}"
      operator  = "="
      value     = "nomad-02"
    }

    network {
      port "http" {
        to = 9705
      }
    }

    service {
      name = "huntarr"
      port = "http"
      provider = "consul"

      # check {
      #   name     = "alive"
      #   type     = "tcp"
      #   port     = "http"
      #   path     = "/huntarr/web"
      #   interval = "10s"
      #   timeout  = "2s"
      #   #expose   = true
      # }

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.huntarr.rule=Host(`huntarr.securitybits.io`)",
        "traefik.http.routers.huntarr.entrypoints=websecure",
        "traefik.http.routers.huntarr.tls.certresolver=letsencrypt",
        "traefik.http.routers.huntarr.middlewares=ip-whitelist@file"
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

    task "huntarr" {
      driver = "docker"
      config {
        image = "huntarr/huntarr"
        ports = [ "http" ]

        mount {
          type = "bind"
          target = "/config"
          source = "/docker/data/Huntarr/config"
          readonly = false
        }

      }

      env {
        TZ      = "Europe/Stockholm"
      }

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