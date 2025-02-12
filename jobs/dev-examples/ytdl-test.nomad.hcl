job "ytdl-test" {
  datacenters = ["*"]
  type = "batch"

  group "ytdl-test" {
    task "ytdl-test" {
      driver = "docker"
      config {
        image   = "busybox:1"
        command = "/bin/sh"
        args    = ["-c", "cat local/channels.txt && echo test > /youtube-dl/test.txt"]

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
        file = "channels.txt"
      }

      template {
        data = <<EOH
        {{- with nomadVar "nomad/jobs/ytdl-test/channels" }}
        {{- range $name, $url := . }}
        # {{ $name }}
        {{ $url }}
        {{ end }}
        {{- end }}
        EOH
        destination = "local/channels.txt"
      }
    }
  }
}