job "radarr" {
  datacenters = [ "*" ]
  type = "service"

  group "radarr" {
    network {
      port "radarr" { 
        to = 7878
      }
    }

    service {
      name = "radarr"
      port = "radarr"
      provider = "consul"

      check {
        name     = "radarr"
        type     = "http"
        port     = "radarr"
        path     = "/ping"
        interval = "30s"
        timeout  = "2s"
        #expose   = true
      }

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.radarr.rule=Host(`radarr.securitybits.io`)",
        "traefik.http.routers.radarr.entrypoints=websecure",
        "traefik.http.routers.radarr.tls.certresolver=letsencrypt",
        "traefik.http.routers.radarr.middlewares=ip-whitelist@file",
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

    task "radarr" {
      driver = "docker"

      env {
        PUID = 1000
        PGID = 1000
        TZ = "Europe/Stockholm"
      }

      config {
        image = "linuxserver/radarr:latest"
        ports = ["radarr"]

        mount {       # Mount Backup Folder
          target = "/backups"
          source = "radarr-backup"

          volume_options {
            no_copy = "false"
            driver_config  {
              name = "local"
              options {
                type = "cifs"
                device = "//10.0.11.241/Securitybits.systems/Radarr"
                o = "vers=3.0,dir_mode=0777,file_mode=0777,username=guest,password=\"\""
              }
            }
          }
        }         
        
        mount {     # Mount Config Folder, TODO: Radarr gnäller på att databasen är låst när man kör på SMB Share
          target = "/config"
          source = "radarr-config"

          volume_options {
            no_copy = "false"
            driver_config  {
              name = "local"
              options {
                type = "cifs"
                device = "//10.0.11.241/Securitybits.systems/Radarr/config"
                o = "vers=3.0,dir_mode=0777,file_mode=0777,username=guest,password=\"\""
              }
            }
          }
        }

        mount {     # Mount Config Folder
          target = "/movies"
          source = "plexmedia-movies"

          volume_options {
            no_copy = "false"
            driver_config  {
              name = "local"
              options {
                type = "cifs"
                device = "//10.0.11.241/PlexMedia/Movies"
                o = "vers=3.0,dir_mode=0777,file_mode=0777,username=guest,password=\"\""
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
                o = "vers=3.0,dir_mode=0777,file_mode=0777,username=guest,password=\"\""
              }
            }
          }
        }
      }

      resources {
        cpu    = 300
        memory = 1024
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