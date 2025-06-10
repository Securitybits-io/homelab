job "sabnzbd" {
  datacenters = ["*"]
  
  type = "service"

  group "sabnzbd" {
    constraint {
      attribute = "${attr.unique.hostname}"
      operator  = "="
      value     = "nomad-02"
    }

    network {
      port "http" {
        to = 8080
      }
    }

    service {
      name = "sabnzbd"
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
        "traefik.http.routers.sabnzbd.rule=Host(`sabnzbd.securitybits.io`)",
        "traefik.http.routers.sabnzbd.entrypoints=websecure",
        "traefik.http.routers.sabnzbd.tls.certresolver=letsencrypt",
        "traefik.http.routers.sabnzbd.middlewares=ip-whitelist@file"
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

    task "sabnzbd" {
      driver = "docker"
      env {
        TZ      = "Europe/Stockholm"
      }
      config {
        image = "linuxserver/sabnzbd"
        ports = [ "http" ]
        
        volumes = [ "/docker/data/Sabnzbd/config":"/config" ]

        mount {
          target = "/downloads"
          source = "sabnzb-downloads"

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
          target = "/incomplete-downloads"
          source = "sabnzb-incomplete-downloads"

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