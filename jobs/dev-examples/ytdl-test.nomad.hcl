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
        #args    = ["-N 5 --playlist-reverse --download-archive /youtube-dl/Test/downloaded.txt -i -o "/youtube-dl/Test/%(uploader)s/%(playlist)s/%(upload_date>%Y)s/%(playlist)s - S%(upload_date>%Y)sE%(playlist_index)s - %(title)s.%(ext)s" -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]" -S vcodec:h264 --merge-output-format mkv --add-metadata --write-thumbnail --write-description --write-auto-subs --sub-langs en,sv,-live_chat --convert-subs srt --batch-file=/local/channels.txt --compat-options playlist-index"]
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