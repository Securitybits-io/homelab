job "tdarr" {
  datacenters = ["*"]

  type        = "service"

  group "tdarr-server" {
    count = 1

    network {
      mode = "host"
      port "web" {
        static = 8265
      }
      port "node" {
        static = 8266
      }
    }

    service {
      name = "tdarr-server"
      tags = ["tdarr", "server"]
      port = "web"
      check {
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.tdarr-server.rule=Host(`tdarr.securitybits.io`)", 
        "traefik.http.routers.tdarr-server.entrypoints=websecure", 
        "traefik.http.routers.tdarr-server.tls.certresolver=letsencrypt", 
        "traefik.http.routers.tdarr-server.middlewares=ip-whitelist@file"
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

    task "tdarr-server" {
      driver = "docker"

      config {
        image = "ghcr.io/haveagitgat/tdarr:latest"
        ports = ["web", "node"]

        mount {
          type = "bind"
          target = "/app"
          source = "/docker/data/Tdarr"
          readonly = false
        }
        
        mount { 
          target = "/media"
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

        devices = [
          "//dev/dri:/dev/dri", # Intel iGPU
        ]
      }

      env {
        TZ                    = "Europe/Stockholm"
        serverIP              = "0.0.0.0"
        serverPort            = "8266"
        webUIPort             = "8265"
        internalNode          = true
        inContainer           = true
        ffmpegVersion         = 7
        nodeName              = "TdarrNode"
        auth                  = false
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
    