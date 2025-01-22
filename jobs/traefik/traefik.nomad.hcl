

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

    task "server" {
      driver = "docker"
      config {
        image = "traefik:3.3.1"
        ports = ["admin", "http"]
        args = [
          "--api.dashboard=true",
          "--api.insecure=true", # not for production
          "--entrypoints.web.address=:${NOMAD_PORT_http}",
          "--entrypoints.websecure.address=:${NOMAD_PORT_https}",
          "--entrypoints.traefik.address=:${NOMAD_PORT_admin}",
          #"--providers.nomad=true",
          #"--providers.nomad.endpoint.address=http://<nomad server ip>:4646" 
          "--providers.consulcatalog=true",
          "--providers.consulcatalog.endpoint.address=http://consul:8500",
          "--providers.file.filename=./config.yml",
          "--providers.file.watch=true"
        ]
        volumes = [
          "/opt/jobs/traefik/config.yml:/local/config.yml",
        ]
      }
      

      # template {
      # data =  <<-EOF
      #         http:
      #           routers:
      #             dashboard-router:
      #               rule: Path(`/dashboard`)
      #               service: internal-dashboard

      #           services:
      #             internal-dashboard:
      #               loadBalancer:
      #                 servers:
      #                   - url: http://10.0.40.6:8080
      #         EOF
      #   destination = "local/config.yml"
      # }

      resources {
        cpu    = 100 # Mhz
        memory = 100 # MB
      }
    }
  }
}
