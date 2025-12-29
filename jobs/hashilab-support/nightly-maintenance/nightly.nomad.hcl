job "nightly-maintenance" {
  datacenters = ["*"]
  type        = "batch"

  periodic {
    crons             = ["0 3 * * *"]
    time_zone         = "Europe/Stockholm"
    prohibit_overlap  = true
  }

  group "nightly" {
    
    task "runner" {
      driver = "exec"

      config {
        command = "/bin/sh"
        args = ["-c", <<EOF
          echo "Nothing to run"
          EOF
        ]
      }

      resources {
        memory  = 100
        cpu     = 100
      }
    }
  }
}