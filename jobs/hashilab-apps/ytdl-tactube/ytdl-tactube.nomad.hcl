job "ytdl-tactube" {
  datacenters = ["*"]
  type = "batch"
  periodic {
    crons = [
        "2 1 * * *"
      ]
    time_zone = "Europe/Stockholm"
    prohibit_overlap = true
  }

  group "ytdl-tactube" {

    service {
      name = "ytdl-tactube"
      provider = "consul"
    }

    task "ytdl-tactube" {
      driver = "docker"
      
      config {
        image   = "jauderho/yt-dlp"
        args    = [
                "--cookies=/local/youtube-cookies.txt",
                "--ignore-errors",
                "--concurrent-fragments=5",
                "--playlist-reverse",
                "--batch-file=/local/channels.txt",
                "--download-archive=/youtube-dl/downloaded.txt",
                "--output=/youtube-dl/%(uploader)s/%(playlist)s/%(upload_date>%Y)s/%(playlist)s - S%(upload_date>%Y)sE%(playlist_index)s - %(title)s.%(ext)s",
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
          source = "ytdl-tactube"
          volume_options {
            no_copy = "false"
            driver_config  {
            name = "local"
              options {
                type = "cifs"
                device = "//10.0.11.241/PlexMedia/Youtube-DL/Tactube"
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
        {{- with nomadVar "nomad/jobs/ytdl-youtube/auth" -}}
        {{ .cookies }}
        {{- end -}}
        EOH
        destination = "local/youtube-cookies.txt"
      }
      
      template {
        data = <<EOH
        {{- with nomadVar "nomad/jobs/ytdl-tactube/channels" }}
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