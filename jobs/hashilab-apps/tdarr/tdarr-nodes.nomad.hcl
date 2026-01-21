job "tdarr-nodes" {
  datacenters = ["*"]

  type        = "service"

  group "tdarr-node" {
    count = 3

    spread {
      attribute = "${node.unique.id}"
      weight = 100
    }
    
    network {
      mode = "host"
    }

    service {
      name = "tdarr-node"
      provider = "consul"
    }

    update {
      max_parallel = 0
    }

    task "tdarr-node" {
      driver = "docker"

      config {
        image = "ghcr.io/haveagitgat/tdarr_node:2.47.01"
        image_pull_timeout = "15m"

        mount {
          type = "bind"
          target = "/app/configs"
          source = "/docker/data/Tdarr/configs"
          readonly = false
        }

        mount {
          type = "bind"
          target = "/app/server"
          source = "/docker/data/Tdarr/server"
          readonly = false
        }
        
        mount { 
          target = "/temp"
          source = "tdarr-transcode-cache"

          volume_options {
            no_copy = "false"
            driver_config  {
              name = "local"
              options {
                type = "cifs"
                device = "//10.0.11.241/PlexMedia/Tdarr/transcode_cache"
                o = "rw,vers=3.0,dir_mode=0777,file_mode=0777,username=guest,password=\"\""
              }
            }
          }
        }

        mount { 
          target = "/movies"
          source = "tdarr-movies"

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

        mount { 
          target = "/series"
          source = "tdarr-series"

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

        mount { 
          target = "/youtube-dl"
          source = "tdarr-youtubedl"

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

      template {
        data = <<EOH
        {{ range service "tdarr-server" }}
        serverIP = "{{ .Address }}"
        {{ end }}
        EOH
        destination = "secrets/file.env"
        env         = true
        change_mode = "noop"
      }

      env {
        PUID                  = "1000"
        PGID                  = "1000"
        TZ                    = "Europe/Stockholm"
        serverPort            = "8266"
        internalNode          = "true"
        inContainer           = "true"
        ffmpegVersion         = "7"
        nodeName              = "tdarr-node-${NOMAD_ALLOC_INDEX}"
        auth                  = "false"
      }
      
      template {
        data = <<EOH
        {{- with nomadVar "nomad/jobs/tdarr-nodes/env" }}
        IMAGE_TAG={{ .IMAGE_TAG }}
        {{- end }}
        EOH
        destination = "local/.env"
        env = true
      }

      resources {
        cpu    = 1000
        memory = 2048
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
    