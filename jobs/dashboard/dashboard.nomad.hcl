job "dashboard" {
  datacenters = ["*"]
  
  type = "service"

  group "dashboard-internal" {
    constraint {
      attribute = "${meta.node_roles}"
      value     = "management"
      operator  = "set_contains_any"
    }

    network {
      port "http" {
        to = 8080
      }
    }

    service {
      name = "dashboard-internal-service"
      port = "http"
      provider = "consul"

      tags = [
        "traefik.enable=true",
        "traefik.http.middlewares.dashboard-strip-prefix.stripPrefix.prefixes=/dashboard",
        "traefik.http.routers.dashboard-router.rule=PathPrefix(`/dashboard`)",
        "traefik.http.routers.dashboard-router.middlewares=dashboard-strip-prefix@consulcatalog"
      ]
    }

    task "server" {
      driver = "docker"

      config {
        image = "phntxx/dashboard"
        ports = ["http"]
        volumes = [
          "local/data:/app/data"
        ]
      }

      template {
        data        = file("data/apps.json")
        destination = "local/data/apps.json"
        change_mode = "restart"
      }
      template {
        data        = file("data/bookmarks.json")
        destination = "local/data/bookmarks.json"
        change_mode = "restart"
      }
      template {
        data        = file("data/greeter.json")
        destination = "local/data/greeter.json"
        change_mode = "restart"
      }
      template {
        data        = file("data/search.json")
        destination = "local/data/search.json"
        change_mode = "restart"
      }
      template {
        data        = file("data/themes.json")
        destination = "local/data/themes.json"
        change_mode = "restart"
      }
    }
  }
}