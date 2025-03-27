job "bazarr" {
  datacenters = [ "*" ]
  type = "service"

  group "bazarr" {
    constraint {
      attribute = "${attr.unique.hostname}"
      operator  = "="
      value     = "nomad-02"
    }

    network {
      port "bazarr" { 
        to = 7878
      }
    }

    service {
      name = "bazarr"
      port = "bazarr"
      provider = "consul"

      check {
        name     = "bazarr"
        type     = "http"
        port     = "bazarr"
        path     = "/ping"
        interval = "30s"
        timeout  = "2s"
        #expose   = true
      }

      # tags = [
      #   "traefik.enable=true",
      #   "traefik.http.routers.bazarr.rule=Host(`bazarr.securitybits.io`)",
      #   "traefik.http.routers.bazarr.entrypoints=websecure",
      #   "traefik.http.routers.bazarr.tls.certresolver=letsencrypt",
      #   "traefik.http.routers.bazarr.middlewares=ip-whitelist@file",
      # ]

      # canary_tags = [
      #   "traefik.enable=false",
      # ]
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

    task "bazarr" {
      driver = "docker"

      env {
        PUID = 1000
        PGID = 1000
        TZ = "Europe/Stockholm"
      }

      config {
        image = "linuxserver/bazarr:latest"
        ports = ["bazarr"]
        volumes = [
            "local/config:/config"
          ]

        mount {       # Mount Backup Folder
          target = "/backup"
          source = "bazarr-backup"

          volume_options {
            no_copy = "false"
            driver_config  {
              name = "local"
              options {
                type = "cifs"
                device = "//10.0.11.241/Securitybits.systems/Bazarr"
                o = "rw,vers=3.0,dir_mode=0777,file_mode=0777,username=guest,password=\"\""
              }
            }
          }
        }

        mount {     # Mount Movies folder
          target = "/Movies"
          source = "Movies"

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

        mount {     # Mount TV-Shows folder
          target = "/Series"
          source = "Series"

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