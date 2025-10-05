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
        mount {
            target = "/config"
            source = "config"
            volume_options {
              no_copy = "false"
              driver_config  {
                name = "local"
                options {
                  type = "nfs"
                  device = "//10.0.11.241/Securitybits.Systems/TestConfig"
                }
              }
            }
          }
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

      resources {
        cpu    = 50
        memory = 100
      }
    }
  }
}

