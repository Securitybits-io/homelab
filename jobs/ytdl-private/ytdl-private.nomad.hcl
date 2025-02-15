job "ytdl-private" {
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
    }

    task "ytdl-private" {
      driver = "docker"
      
      config {
        image   = "jauderho/yt-dlp"
        args    = [
                "--ignore-errors",
                "--concurrent-fragments=10",
                "--playlist-reverse",
                "--batch-file=/local/channels.txt",
                "--download-archive=/youtube-dl/videos/downloaded.txt",
                "--output=/youtube-dl/videos/%(webpage_url_domain)s/%(playlist)s/%(title)s.%(ext)s",
                "--format=bestvideo[ext=mp4]+bestaudio[ext=m4a]",
                "--format-sort=vcodec:h264",
                "--merge-output-format=mkv",
                "--add-metadata",
                "--write-thumbnail",
                "--write-description",
                "--write-auto-subs",
                "--sub-langs=en,sv,-live_chat",
                "--convert-subs=srt",
                "--compat-options=playlist-index"
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
                device = "//10.0.11.241/PlexMedia/Youtube-DL/Test"
                o = "vers=3.0,file_mode=0660,dir_mode=0660,username=private,password=${SMB_PASS}"
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