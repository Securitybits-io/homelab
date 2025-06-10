job "nzbget" {
  datacenters = ["*"]
  
  type = "service"

  group "nzbget" {
    constraint {
      attribute = "${attr.unique.hostname}"
      operator  = "="
      value     = "nomad-02"
    }

    network {
      port "http" {
        to = 6789
      }
    }

    service {
      name = "nzbget"
      port = "http"
      provider = "consul"

      check {
        name     = "alive"
        type     = "tcp"
        port     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
        #expose   = true
      }

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.nzbget.rule=Host(`nzbget.securitybits.io`)",
        "traefik.http.routers.nzbget.entrypoints=websecure",
        "traefik.http.routers.nzbget.tls.certresolver=letsencrypt",
        "traefik.http.routers.nzbget.middlewares=ip-whitelist@file"
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

    task "nzbget" {
      driver = "docker"
      env {
        PUID = 0
        PGID = 0
        TZ   = "Europe/Stockholm"
      }
      config {
        image = "linuxserver/nzbget"
        ports = [ "http" ]

        mount {
          type = "bind"
          target = "/config"
          source = "/docker/data/NZBGet/config"
          readonly = false
        }

        mount {
          target = "/downloads"
          source = "nzbget-downloads"

          volume_options {
            no_copy = "false"
            driver_config  {
              name = "local"
              options {
                type = "cifs"
                device = "//10.0.11.241/PlexMedia/Downloads/complete"
                o = "rw,vers=3.0,dir_mode=0777,file_mode=0777,username=guest,password=\"\""
              }
            }
          }
        }

        mount {
          target = "/intermediate"
          source = "nzbget-incomplete-downloads"

          volume_options {
            no_copy = "false"
            driver_config  {
              name = "local"
              options {
                type = "cifs"
                device = "//10.0.11.241/PlexMedia/Downloads/incomplete"
                o = "rw,vers=3.0,dir_mode=0777,file_mode=0777,username=guest,password=\"\""
              }
            }
          }
        }
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