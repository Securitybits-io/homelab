job "ytdl-private" { # In progress
  datacenters = ["*"]
  type = "batch"
  periodic {
    crons = [
        "2 2 * * *"
      ]
    time_zone = "Europe/Stockholm"
    prohibit_overlap = true
  }

  group "ytdl-private" {

    service {
      name = "ytdl-private"
      provider = "consul"
      tags = [
        "diun.enable=false",
      ]
    }

    task "ytdl-private" {
      driver = "docker"
      
      config {
        image   = "securitybits/yt-dlp"
        args    = [
                "--ignore-errors",
                "--concurrent-fragments=10",
                "--playlist-reverse",
                "--batch-file=/local/channels.txt",
                "--download-archive=/youtube-dl/videos/downloaded.txt",
                "--output=/youtube-dl/videos/%(webpage_url_domain)s/%(playlist)s/%(title)s.%(ext)s",
                "--merge-output-format=mkv",
                "--add-metadata",
                "--write-thumbnail",
                "--write-description",
                "--compat-options playlist-index",
                "--write-info-json",
                "--embed-metadata",
                "--embed-thumbnail"
                ]

        mount {
          target = "/youtube-dl"
          source = "ytdl-private"
          volume_options {
            no_copy = "false"
            driver_config  {
            name = "local"
              options {
                type = "cifs"
                device = "//10.0.11.241/Securitybits.Private"
                o = "vers=3.0,file_mode=0777,dir_mode=0777,username=private,password=${SMB_PASS}"
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
        SMB_PASS="{{ with nomadVar "nomad/jobs/ytdl-private/secrets" }}{{ .SMB_PASS }}{{ end }}"  
        EOH
        destination = "secrets/smb.env"
        change_mode = "noop"
        env = true
      }
      
      template {
        data = <<EOH
        {{- with nomadVar "nomad/jobs/ytdl-private/channels" }}
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