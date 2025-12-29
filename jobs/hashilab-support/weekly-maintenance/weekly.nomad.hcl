job "weekly-maintenance" {
  datacenters = ["*"]
  type        = "sysbatch"

  periodic {
    crons       = ["15 3 * * Sun"]
    time_zone   = "Europe/Stockholm"
    prohibit_overlap = true
  }

  group "docker" {
 
    task "maintenance" {
      driver = "raw_exec"

      config {
        command = "/bin/sh"

        args = ["-c", <<EOF
          echo "running weekly maintenance on $(hostname).home"
          echo "cleaning up docker resources"
          docker system prune --all --force
          docker image prune --all --force
          echo "finished cleaning up docker resources"
          apt autoremove --purge -y
          echo "finished cleaning up outdated apt packages"
          journalctl --vacuum-time=7d 2>&1
          echo "finished purging old log data from journald"
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