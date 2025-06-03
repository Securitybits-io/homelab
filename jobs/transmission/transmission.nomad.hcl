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

      tags = [
        # "traefik.enable=true",
        # "traefik.http.routers.transmission.rule=Host(`transmission.securitybits.io`)",
        # "traefik.http.routers.transmission.entrypoints=websecure",
        # "traefik.http.routers.transmission.tls.certresolver=letsencrypt",
        # "traefik.http.routers.transmission.middlewares=ip-whitelist@file"
      ]

      check {
        name     = "alive"
        type     = "tcp"
        port     = "http"
        path     = "/transmission/web"
        interval = "10s"
        timeout  = "2s"
        #expose   = true
      }
    }

    task "transmission" {
      driver = "docker"
      config {
        image = "haugene/transmission-openvpn"
        ports = ["http"]
        cap_add = ["NET_ADMIN"]
        volumes = [
          "local/vpn/:/etc/openvpn/custom/"
        ]
      }

      env {
        TZ="Europe/Stockholm"
        OPENVPN_PROVIDER=custom
        OPENVPN_CONFIG=airvpn
        LOCAL_NETWORK="10.0.0.0/16"
        TRANSMISSION_WEB_UI=flood-for-transmission
        TRANSMISSION_PREALLOCATION=1
        TRANSMISSION_RATIO_LIMIT=0
        TRANSMISSION_RATIO_LIMIT_ENABLED=True
        TRANSMISSION_DOWNLOAD_QUEUE_SIZE=200
        TRANSMISSION_DOWNLOAD_DIR="/downloads/complete"
        TRANSMISSION_INCOMPLETE_DIR="/downloads/incomplete"
      }

      

      template {
        data = <<EOF
          {{- with nomadVar "nomad/jobs/transmission/secrets" -}}
          {{ base64Decode .OPENVPN_FILE.Value }}
          {{- end }}
        EOF
        destination = "local/vpn/airvpn.openvpn"
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
    }
  }
}