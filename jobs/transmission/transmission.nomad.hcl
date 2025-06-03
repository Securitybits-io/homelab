job "transmission" {
  datacenters = ["*"]
  
  type = "service"

  group "transmission" {
    constraint {
      attribute = "${meta.node_roles}"
      value     = "web"
      operator  = "set_contains_any"
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
      }

      env {
        TZ="Europe/Stockholm"
        OPENVPN_PROVIDER=custom
        OPENVPN_CONFIG=airvpn
        # OPENVPN_USERNAME=${OPENVPN_USER}
        # OPENVPN_PASSWORD=${OPENVPN_PASS}
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
        data        = <<-EOT
          {{- with nomadVar "nomad/jobs/transmission/secrets" }}
          {{ base64Decode .OPENVPN_FILE }}
          {{- end }}
        EOT
        destination = "/etc/openvpn/custom/airvpn.openvpn"
        change_mode = "restart"
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