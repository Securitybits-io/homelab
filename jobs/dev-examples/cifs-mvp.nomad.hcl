job "cifs-mvp" {
  datacenters = ["*"]
  type = "service"
  
  group "cifs-mvp" {
    task "cifs-mvp" {
      driver = "docker"
      config {
        image   = "busybox:1"
        mount {
          target = "/share"
          source = "cifs-mvp"
          volume_options {
            no_copy = "false"
            driver_config  {
            name = "local"
              options {
                type = "cifs"
                device = "//qnap/cifs-mvp"
                o = "vers=3.0,file_mode=0660,dir_mode=0660,username=private,password=$SMB_PASS"
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

