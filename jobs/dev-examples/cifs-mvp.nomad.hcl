job "cifs-mvp" {
  datacenters = ["*"]
  type = "service"
  
  group "cifs-mvp" {
    task "cifs-mvp" {
      driver = "docker"
      config {
        image   = "securitybits/yt-dlp"
        mount {
          target = "/youtube-dl"
          source = "youtube-dl"
          volume_options {
            no_copy = "false"
            driver_config  {
            name = "local"
              options {
                type = "cifs"
                device = "//10.0.11.241/Securitybits.Private"
                o = "vers=3.0,file_mode=0660,dir_mode=0660,username=private,password=${SMB_PASS}"
              }
            }
          }
        }
      }
      
      template {
        data = <<EOH
        SMB_PASS="{{ with nomadVar "nomad/jobs/ytdl-private/secrets" }}{{ .SMB_PASS }}{{ end }}"  
        EOH
        destination = "secrets/smb.env"
        env = true
      }
    }
  }
}

