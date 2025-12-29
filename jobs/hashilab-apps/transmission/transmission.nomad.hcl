job "transmission" {
  datacenters = ["*"]
  
  type = "service"

  group "transmission" {
    constraint {
      attribute = "${attr.unique.hostname}"
      operator  = "="
      value     = "nomad-02"
    }

    network {
      port "http" {
        to = 9091
      }
    }

    service {
      name = "transmission"
      port = "http"
      provider = "consul"

      check {
        name     = "alive"
        type     = "tcp"
        port     = "http"
        path     = "/transmission/web"
        interval = "10s"
        timeout  = "2s"
        #expose   = true
      }

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.transmission.rule=Host(`transmission.securitybits.io`)",
        "traefik.http.routers.transmission.entrypoints=websecure",
        "traefik.http.routers.transmission.tls.certresolver=letsencrypt",
        "traefik.http.routers.transmission.middlewares=ip-whitelist@file"
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

    task "transmission" {
      driver = "docker"
      config {
        image = "haugene/transmission-openvpn"
        ports = [ "http" ]
        cap_add = [ "NET_ADMIN" ]
        volumes = [
          "local/vpn:/etc/openvpn/custom"
        ]

        mount {
          target = "/downloads"
          source = "transmission-downloads"

          volume_options {
            no_copy = "false"
            driver_config  {
              name = "local"
              options {
                type = "cifs"
                device = "//10.0.11.241/PlexMedia/Downloads"
                o = "rw,vers=3.0,dir_mode=0777,file_mode=0777,username=guest,password=\"\""
              }
            }
          }
        }
      }

      env {
        TZ      = "Europe/Stockholm"
        OPENVPN_PROVIDER  = "custom"
        OPENVPN_CONFIG    = "airvpn"
        LOCAL_NETWORK     = "10.0.0.0/16"
        TRANSMISSION_WEB_UI = "flood-for-transmission"
        TRANSMISSION_PREALLOCATION  = 1
        TRANSMISSION_RATIO_LIMIT    = 0
        TRANSMISSION_RATIO_LIMIT_ENABLED  = True
        TRANSMISSION_DOWNLOAD_QUEUE_SIZE  = 200
        TRANSMISSION_DOWNLOAD_DIR     = "/downloads/complete"
        TRANSMISSION_INCOMPLETE_DIR   = "/downloads/incomplete"
      }

      template {
        data = <<EOF
          {{- with nomadVar "nomad/jobs/transmission/secrets" -}}
          {{ base64Decode .OPENVPN_FILE.Value }}
          {{- end }}
        EOF
        destination = "local/vpn/airvpn.ovpn"
        change_mode = "restart"
        env = false
      }

      template {
        data = <<EOH
        {{- with nomadVar "nomad/jobs/transmission/secrets" }}
        OPENVPN_USERNAME={{ .OPENVPN_USER }}
        OPENVPN_PASSWORD={{ .OPENVPN_PASS }}
        {{- end }}
        EOH
        destination = "secrets/openvpn_creds.env"
        change_mode = "noop"
        env = true
      }

      resources {
        cpu    = 500
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