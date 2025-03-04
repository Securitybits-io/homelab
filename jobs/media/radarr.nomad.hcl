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

      check {
        name     = "radarr"
        type     = "http"
        port     = "radarr"
        path     = "/ping"
        interval = "30s"
        timeout  = "2s"
        expose   = true
      }
    }

    task "radarr" {
      driver = "docker"

      config {
        image = "linuxserver/radarr:latest"
        ports = ["radarr"]
        env {
          PUID = 1000
          PGID = 1000
          TZ = "Europe/Stockholm"
        }

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
        
        mount {     # Mount Config Folder
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
    }
  }
}