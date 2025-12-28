job "mqtt" {
  datacenters = ["*"]
  type        = "service"

  group "mosquitto" {
    count = 1

    network {
      port "mqtt" {
        static = 1883
      }
      # port "ws" {
      #   static = 9001
      # }
    }

    service {
      name     = "mosquitto"
      port     = "mqtt"
      provider = "consul"

      tags = [
        "traefik.enable=true",
        "traefik.tcp.routers.mqtt.rule=HostSNI(`*`)",
        "traefik.tcp.routers.mqtt.entrypoints=mqtt",
      ]

      check {
        type     = "tcp"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "mosquitto" {
      driver = "docker"

      config {
        image = "eclipse-mosquitto:2"
        ports = ["mqtt"]
        # ports = ["mqtt", "ws"]

        volumes = [
          "local/mosquitto.conf:/mosquitto/config/mosquitto.conf",
        ]
      }

      template {
        destination = "local/mosquitto.conf"
        change_mode = "restart"
        data        = <<EOF
persistence true
persistence_location /mosquitto/data/
log_dest stdout

listener 1883
allow_anonymous true

# listener 9001
# protocol websockets

# Bridge Configuration
connection bridge-to-remote
address mqtt.meshtastic.liamcottle.net:1883
topic # out 0
topic # in 0
remote_username uplink
remote_password uplink
EOF
      }

      resources {
        cpu    = 200
        memory = 256
      }
    }
  }
}
