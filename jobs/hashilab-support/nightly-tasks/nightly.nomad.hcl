job "nightly-tasks" {
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

    task "plex-cleanup-crew" {
      driver = "docker"

      config {
        image = "alpine:latest"
        command = "find"
        args = ["/plexmedia-bin", 
                "-mindepth", "1",
                "-depth",
                "-mtime", "+3",
                "-delete"]

        mount {
          target = "/plexmedia-bin"
          source = "plexmedia"
          volume_options {
            no_copy = "false"
            driver_config  {
            name = "local"
              options {
                type = "cifs"
                device = "//10.0.11.241/PlexMedia/@Recycle"
                o = "vers=3.0,dir_mode=0777,file_mode=0777,username=guest,password=\"\""
              }
            }
          }
        }
      }

      resources {
        memory  = 100
        cpu     = 100
      }
    }
  }
}