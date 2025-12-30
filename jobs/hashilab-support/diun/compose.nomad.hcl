job "diun" {
  datacenters = ["*"]
  type        = "service"

  group "diun" {

    ephemeral_disk {
      migrate = true
    }

    task "server" {
      driver = "docker"

      config {
        image = "crazymax/diun:latest"

        args = ["server",
                "--config", "/secrets/diun.yaml"
        ]
      }
      
      env {
        TZ = "Europe/Stockholm"
        DIUN_DB_PATH = "${NOMAD_ALLOC_DIR}/data/diun.db"
      }

      resources {
        memory = 64
        cpu    = 100
      }

      template {
        change_mode = "restart"
        left_delimeter = "[["
        right_delimeter = "]]"
        destination = "/secrets/diun.yaml"
        data = <<EOH

        [[ with nomadVar "nomad/jobs/diun/secrets" ]]


defaults:
  watchRepo: false
  notifyOn:
    - new
    - update

#db:            # configuration via yaml does not work, using env
#  path: "[[ env "NOMAD_ALLOC_DIR" ]]/data/diun.db"

watch:
  schedule: "0 */6 * * *"
  compareDigest: true
  firstCheckNotif: true
  runOnStartup: true


notif:
  discord: #CHANGE BEFORE COMMIT
    webhookURL: [[ .webhookURL ]]
    renderEmbeds: true
    renderFields: true
    timeout: 10s
    templateBody: |
      Docker tag {{ .Entry.Image }} which you subscribed to through {{ .Entry.Provider }} provider has been released.

providers:
  nomad:
    watchByDefault: true
    address: "http://[[ env "attr.unique.network.ip-address" ]]:4646/"

        [[ end ]]
        EOH

      }
    }
  }
}