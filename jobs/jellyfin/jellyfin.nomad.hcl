job "jellyfin" {
  datacenters = [ "*" ]
  type = "service"

  group "jellyfin" {
    network {
      port "jellyfin" { 
        to = 8096
      }
    }

    service {
      name = "jellyfin"
      port = "jellyfin"
      provider = "consul"

      check {
        name     = "jellyfin"
        type     = "http"
        port     = "jellyfin"
        path     = "/ping"
        interval = "30s"
        timeout  = "2s"
        #expose   = true
      }

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.jellyfin.rule=Host(`jellyfin.securitybits.io`)",
        "traefik.http.routers.jellyfin.entrypoints=websecure",
        "traefik.http.routers.jellyfin.tls.certresolver=letsencrypt",
        "traefik.http.routers.jellyfin.middlewares=ip-whitelist@file",
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

    task "jellyfin" {
      driver = "docker"

      env {
        PUID = 1000
        PGID = 1000
        TZ = "Europe/Stockholm"
      }

      config {
        image = "jellyfin/jellyfin:latest"
        ports = ["jellyfin"]

        volumes = [
          "/docker/data/Jellyfin/config:/config",
          "/docker/data/Jellyfin/cache:/cache"
        ]

        mount {     # Mount Config Folder
          target = "/data/movies"
          source = "plexmedia-movies"

          volume_options {
            no_copy = "false"
            driver_config  {
              name = "local"
              options {
                type = "cifs"
                device = "//10.0.11.241/PlexMedia/Movies"
                o = "rw,vers=3.0,dir_mode=0777,file_mode=0777,username=guest,password=\"\""
              }
            }
          }
        }

        mount {     # Mount Config Folder
          target = "/data/tvshows"
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

        mount {     # Mount Config Folder
          target = "/data/youtube"
          source = "plexmedia-youtube"

          volume_options {
            no_copy = "false"
            driver_config  {
              name = "local"
              options {
                type = "cifs"
                device = "//10.0.11.241/PlexMedia/Youtube-DL"
                o = "rw,vers=3.0,dir_mode=0777,file_mode=0777,username=guest,password=\"\""
              }
            }
          }
        }  
      }

      resources {
        cpu    = 4000
        memory = 4096
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