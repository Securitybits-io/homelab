job "ytdl-test" {
  datacenters = ["*"]
  type = "batch"

  parameterized {
    meta_optional = ["MY_META_KEY"]
  }

  group "ytdl-test" {
    task "ytdl-test" {
      driver = "docker"
      config {
        image   = "busybox:1"
        command = "/bin/sh"
        args    = ["-c", "cat local/template.out", "local/payload.txt"]

        mount {
            target = "/youtube-dl"
            source = "ytdl-test"
            volume_options {
                no_copy = "false"
                driver_config  {
                name = "local"
                    options {
                        type = "cifs"
                        device = "//10.0.11.241/PlexMedia/Youtube-DL/Test"
                        o = "vers=3.0,dir_mode=0777,file_mode=0777,username=guest,password=\"\""
                    }
                }
            }
        }
      }

      dispatch_payload {
        file = "payload.txt"
      }

      template {
        data = <<EOH
MY_META_KEY: {{env "NOMAD_META_MY_META_KEY"}}
  EOH

        destination = "local/template.out"
      }
    }
  }
}