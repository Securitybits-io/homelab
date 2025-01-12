job "traefik" {
  datacenters = ["*"]
  type        = "service"
  
  constraint {
        attribute = "${meta.node_roles}"
        value     = "ingress"
        operator  = "contains"
    }

  group "traefik" {

    service {
      name 			= "traefik-http"
      port 			= "http"
      
    } # Add healthcheck on 8080

    network {
      mode = "host"
      port  "http" {
         static = 80
      }
      port  "admin" {
         static = 8080
      }
    }

    task "server" {
      driver = "docker"
      config {
        image = "traefik:3.3.1"
        ports = ["admin", "http"]
        args = [
          "--api.dashboard=true",
          "--api.insecure=true", # not for production
          "--entrypoints.web.address=:${NOMAD_PORT_http}",
          "--entrypoints.traefik.address=:${NOMAD_PORT_admin}",
          #"--providers.nomad=true",
          #"--providers.nomad.endpoint.address=http://<nomad server ip>:4646" 
          "--providers.consulcatalog.endpoint.address=http://consul:8500"
        ]
      }

      resources {
        cpu    = 100 # Mhz
        memory = 100 # MB
      }
    }
  }
}