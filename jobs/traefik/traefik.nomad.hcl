

job "traefik" {
  datacenters = ["*"]
  type        = "service"
   
  group "traefik" {
  
    constraint {
          attribute = "${meta.node_roles}"
          value     = "ingress"
          operator  = "set_contains_any"
      }

    service {
        name 			= "traefik-http"
        port 			= "http"
        
    } # Add healthcheck on 8080

    network {
      mode = "host"
      port  "http" {
        static = 80
      }
      port "https" {
        static = 443
      }
      port  "admin" {
        static = 8080
      }
    }

    ephemeral_disk {
      migrate = true
      size    = 300
      sticky  = true
    }

    task "proxy" {
      driver = "docker"
      config {
        image = "traefik:3.3.1"
        ports = ["admin", "http","https"]
        args = [
          "--api.dashboard=true",
          "--api.insecure=true", # not for production
          "--entrypoints.web.address=:${NOMAD_PORT_http}",
          "--entrypoints.websecure.address=:${NOMAD_PORT_https}",
          "--entrypoints.traefik.address=:${NOMAD_PORT_admin}",
          "--certificatesresolvers.letsencrypt.acme.tlschallenge=true",
          "--certificatesresolvers.letsencrypt.acme.email=christoffer.claesson@outlook.com",
          "--certificatesresolvers.letsencrypt.acme.storage=/local/acme.json",
          "--providers.consulcatalog=true",
          "--providers.consulcatalog.endpoint.address=http://consul:8500",
          "--providers.file.filename=/local/config.yml",
          "--providers.file.watch=true"
        ]
      }

      template {
        data        = file("./config.yml")
        destination = "local/config.yml"
        change_mode = "restart"
      }

      resources {
        cpu    = 100 # Mhz
        memory = 100 # MB
      }
    }
  }
}
