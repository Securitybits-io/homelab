job "tautulli" {
  datacenters = ["*"]

  type = "service"

  group "tautulli" {
    count = 1

    constraint {
      attribute = "${attr.unique.hostname}"
      operator  = "="
      value     = "nomad-02"
    }

    network {
      mode = "host"
      port "http" {
        static = 8181
      }
    }

    service {
      name     = "tautulli"
      port     = "http"
      provider = "consul"

      check {
        name     = "alive"
        type     = "tcp"
        port     = "http"
        path     = "/status"
        interval = "10s"
        timeout  = "2s"
      }

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.tautulli.rule=Host(`tautulli.securitybits.io`)",
        "traefik.http.routers.tautulli.entrypoints=websecure",
        "traefik.http.routers.tautulli.tls.certresolver=letsencrypt",
        "traefik.http.routers.tautulli.middlewares=ip-whitelist@file"
      ]

      canary_tags = [
        "traefik.enable=false",
      ]
    }

    update {
      max_parallel      = 1
      min_healthy_time  = "10s"
      healthy_deadline  = "3m"
      progress_deadline = "10m"
      auto_revert       = true
    }

    task "tautulli" {
      driver = "docker"

      config {
        image = "tautulli/tautulli:latest"
        ports = ["http"]
      }

      mount {
        type = "bind"
        target = "/config"
        source = "/docker/data/Tautulli/config"
        readonly = false
      }

      env {
        PUID = "1000"
        PGID = "1000"
        TZ   = "Europe/Stockholm"
      }

      resources {
        cpu    = 200
        memory = 512
      }

      restart {
        attempts = 3
        delay    = "15s"
        mode     = "delay"
      }

      kill_timeout = "20s"
    }
  }
}
