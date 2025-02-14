job "cifs-example" {
  datacenters = ["*"]
  type = "service"
  
  group "cache" {

    constraint {
      attribute = "${meta.node_roles}"
      value     = "management"
      operator  = "set_contains_any"
    }

    network {
      port "www" {
        to = 8001
      }
    }

    task "server" {

      driver = "docker"
      config {
        image   = "busybox:1"
        command = "httpd"
        args    = ["-v", "-f", "-p", "${NOMAD_PORT_www}", "-h", "/local"]
        ports   = ["www"]
      #   mount {
      #       target = "/Movies"
      #       source = "Movies"
      #       volume_options {
      #         no_copy = "false"
      #         driver_config  {
      #           name = "local"
      #           options {
      #             type = "cifs"
      #             device = "//10.0.11.241/PlexMedia/Movies"
      #             o = "vers=3.0,dir_mode=0777,file_mode=0777,username=guest,password=\"\""
      #           }
      #         }
      #       }
      #     }
       
      #   mount {
      #     target = "/Shows"
      #     source = "Shows"
      #     volume_options {
      #       no_copy = "false"
      #       driver_config  {
      #         name = "local"
      #         options {
      #           type = "cifs"
      #           device = "//10.0.11.241/PlexMedia/Series"
      #           o = "vers=3.0,dir_mode=0777,file_mode=0777,username=guest,password=\"\""
      #         }
      #       }
      #     }
      #   }
      }
      template {
        data        = <<-EOF
                      <h1>Hello, Nomad!</h1>
                      <ul>
                        <li>Task: {{env "NOMAD_TASK_NAME"}}</li>
                        <li>Group: {{env "NOMAD_GROUP_NAME"}}</li>
                        <li>Job: {{env "NOMAD_JOB_NAME"}}</li>
                        <li>Metadata value for foo: {{env "NOMAD_META_foo"}}</li>
                        <li>Currently running on port: {{env "NOMAD_PORT_www"}}</li>
                      </ul>
                      EOF
        destination = "local/index.html"
      }

      template {
        data = <<EOH
        SMB_PASS="{{ with nomadVar "nomad/jobs/ytdl-private/secrets" }}{{ .SMB_PASS }}{{ end }}"  
        EOH
        destination = "secrets/smb.env"
        change_mode = "noop"
        env = true
      }

      resources {
        cpu    = 50
        memory = 100
      }
    }
  }
}

