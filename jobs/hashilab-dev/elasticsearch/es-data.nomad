job "elasticsearch-data" {
  datacenters = ["dc"]

  constraint {
    attribute = "${meta.node_roles}"
    operator  = "=="
    value     = "dev"
  }

  group "data-nodes" {
    # You can now scale this from 1 to 3+ on the same host
    count = 2

    scaling {
      enabled = true
      min     = 1
      max     = 5
    }

    network {
      mode = "bridge"
    }

    volume "es_storage" {
      type      = "host"
      read_only = false
      source    = "es_base"
    }

    service {
      name = "es-data"
      port = "9200"
      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "es-master"
              local_bind_port  = 9300
            }
          }
        }
      }
    }

    task "elasticsearch" {
      driver = "docker"

      volume_mount {
        volume      = "es_storage"
        # We append the allocation index so each node gets its own folder
        destination = "/mnt/data"
      }

      config {
        image = "elastic/elasticsearch:8.1.0"
        image_pull_timeout = "40m"
        entrypoint = ["/bin/sh", "-c", "mkdir -p /mnt/data/node-${NOMAD_ALLOC_INDEX} && /usr/local/bin/docker-entrypoint.sh"]
      }

      env {
# Using standardized ES_ prefix and underscore replacement
        ES_NODE_NAME           = "data-${NOMAD_ALLOC_INDEX}"
        ES_NODE_ROLES          = "data,ingest"
        ES_PATH_DATA            = "/mnt/data/node-${NOMAD_ALLOC_INDEX}"
        ES_CLUSTER_NAME        = "breachsearch-cluster"
        ES_DISCOVERY_SEED_HOSTS = "127.0.0.1:9300"
        ES_JAVA_OPTS           = "-Xms1g -Xmx1g"
        XPACK_SECURITY_ENABLED = "false"
      }

      resources {
        cpu    = 1000
        memory = 1500 # Ensure your host has enough RAM for (count * memory)
      }
    }
  }
}