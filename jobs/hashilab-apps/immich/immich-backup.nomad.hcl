job "immich-backup" {
  type = "batch"

  periodic {
    crons             = [ "30 0 * * *" ]
    prohibit_overlap = true
  }

  group "automation" {
    task "backup" {
      driver = "exec"

      config {
        image = "hashicorp/nomad:latest"
        # nomad job action -task=database -group=backend -job=immich backup-postgres
        command = "/usr/bin/nomad"
        args = [
          "job", "action",
          "-task", "database",      # The specific task
          "-group", "backend",      # The group name"
          "-job", "immich",         # The job name
          "backup-postgres"
        ]
      }

      env {
        NOMAD_ADDR = "http://nomad:4646" # Point to your cluster
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}