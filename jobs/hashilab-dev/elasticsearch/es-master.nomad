job "elasticsearch-master" {
  datacenters = ["dc"]
  type        = "service"

  constraint {
    attribute = "${meta.node_roles}"
    operator  = "=="
    value     = "dev"
  }

  group "master" {
    count = 3

    ephemeral_disk {
      size    = 2048 # 2GB
      sticky  = true
      migrate = true
    }

    network {
      mode = "bridge"
      port "api"       {} 
      port "transport" {}
    }

    # API Service: Uses the dynamic port "api"
    service {
      name = "es-master-api"
      port = "api"
      connect {
        sidecar_service {}
      }
      # check {
      #   type     = "http"
      #   path     = "/_cluster/health"
      #   port     = "api"
      #   interval = "10s"
      #   timeout  = "2s"
      # }
    }

    # Transport Service: Uses the dynamic port "transport"
    service {
      name = "es-master-transport"
      port = "transport"
    }

    task "master" {
      driver = "docker"

      template {
        data = <<EOF
cluster.name: breachsearch-cluster
node.name: master-{{ env "NOMAD_ALLOC_INDEX" }}
network.host: 0.0.0.0
discovery.seed_hosts: ["es-master-transport.service.consul"]
cluster.initial_master_nodes: [{{ range $idx, $s := service "es-master-transport" }}{{ if $idx }},{{ end }}"{{ $s.Address }}:{{ $s.Port }}"{{ end }}]
EOF
        destination = "local/elastic/elasticsearch.yml"
      }

      config {
        image = "elastic/elasticsearch:8.1.0"
        volumes = [
          "local/elastic/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml",
        ]
      }

      env {
        ES_JAVA_OPTS         = "-Xms512m -Xmx512m"
        XPACK_SECURITY_ENABLED = "false"
        ELASTIC_PASSWORD     = "changeme"
      }

      resources {
        cpu    = 1024
        memory = 2048
      }
    }
  }
}