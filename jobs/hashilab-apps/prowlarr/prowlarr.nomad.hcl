job "prowlarr" {
  datacenters = [ "*" ]
  type = "service"

  group "prowlarr" {
    constraint {
      attribute = "${attr.unique.hostname}"
      operator  = "="
      value     = "nomad-02"
    }

    network {
      port "prowlarr" { 
        to = 9696
      }
    }

    service {
      name = "prowlarr"
      port = "prowlarr"
      provider = "consul"

      check {
        name     = "prowlarr"
        type     = "http"
        port     = "prowlarr"
        path     = "/"
        interval = "30s"
        timeout  = "2s"
        #expose   = true
      }

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.prowlarr.rule=Host(`prowlarr.securitybits.io`)",
        "traefik.http.routers.prowlarr.entrypoints=websecure",
        "traefik.http.routers.prowlarr.tls.certresolver=letsencrypt",
        "traefik.http.routers.prowlarr.middlewares=ip-whitelist@file",
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

    ephemeral_disk {    # Kan man använda ephemeral istället för SMB Share, så att den migrerar med containern? går det ändra /config location
      migrate = true
      size = 1000
      sticky = true
    }

    task "prowlarr" {
      driver = "docker"

      env {
        PUID = 1000
        PGID = 1000
        TZ = "Europe/Stockholm"
      }

      config {
        image = "linuxserver/prowlarr:latest"
        ports = ["prowlarr"]
        
        mount {
          type = "bind"
          target = "/config"
          source = "/docker/data/Prowlarr/config"
          readonly = false
        }

        mount {       # Mount Backup Folder
          target = "/backup"
          source = "prowlarr-backup"

          volume_options {
            no_copy = "false"
            driver_config  {
              name = "local"
              options {
                type = "cifs"
                device = "//10.0.11.241/Securitybits.systems/Prowlarr"
                o = "rw,vers=3.0,dir_mode=0777,file_mode=0777,username=guest,password=\"\""
              }
            }
          }
        }
      }

      resources {
        cpu    = 300
        memory = 512
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