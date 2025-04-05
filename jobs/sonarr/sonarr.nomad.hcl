job "sonarr" {
  datacenters = [ "*" ]
  type = "service"

  group "sonarr" {
    constraint {
      attribute = "${attr.unique.hostname}"
      operator  = "="
      value     = "nomad-02"
    }

    network {
      port "sonarr" { 
        to = 8989
      }
    }

    service {
      name = "sonarr"
      port = "sonarr"
      provider = "consul"

      check {
        name     = "sonarr"
        type     = "http"
        port     = "sonarr"
        path     = "/ping"
        interval = "30s"
        timeout  = "2s"
        #expose   = true
      }

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.sonarr.rule=Host(`sonarr.securitybits.io`)",
        "traefik.http.routers.sonarr.entrypoints=websecure",
        "traefik.http.routers.sonarr.tls.certresolver=letsencrypt",
        "traefik.http.routers.sonarr.middlewares=ip-whitelist@file",
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

    task "sonarr" {
      driver = "docker"

      env {
        PUID = 1000
        PGID = 1000
        TZ = "Europe/Stockholm"
      }

      config {
        image = "linuxserver/sonarr:latest"
        ports = ["sonarr"]
        volumes = [
            "local/config:/config"
          ]

        mount {       # Mount Backup Folder
          target = "/backups"
          source = "sonarr-backup"

          volume_options {
            no_copy = "false"
            driver_config  {
              name = "local"
              options {
                type = "cifs"
                device = "//10.0.11.241/Securitybits.systems/Sonarr"
                o = "rw,vers=3.0,dir_mode=0777,file_mode=0777,username=guest,password=\"\""
              }
            }
          }
        }

        mount { 
          target = "/tv"
          source = "plexmedia-series"

          volume_options {
            no_copy = "false"
            driver_config  {
              name = "local"
              options {
                type = "cifs"
                device = "//10.0.11.241/PlexMedia/Series"
                o = "rw,vers=3.0,dir_mode=0777,file_mode=0777,username=guest,password=\"\""
              }
            }
          }
        }

        mount {     # Mount downloads folder
          target = "/downloads/complete"
          source = "downloads-complete"

          volume_options {
            no_copy = "false"
            driver_config  {
              name = "local"
              options {
                type = "cifs"
                device = "//10.0.11.241/PlexMedia/downloads/complete"
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