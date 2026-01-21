job "immich" {
  datacenters = ["*"]
  type        = "service"

  group "server" {
    count = 1

    network {
      mode = "bridge"

      port "http" {
        to     = 2283
      }
    }

    # Use Consul Connect sidecars for inter-container traffic
    service {
      name = "immich-server"
      port = "http"
      
      # Traefik configuration via tags
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.immich.rule=Host(`immich.securitybits.io`)",
        "traefik.http.routers.immich.entrypoints=websecure",
        "traefik.http.routers.immich.tls.certresolver=letsencrypt",
        "traefik.http.routers.immich.middlewares=limitBodySize@file"
      ]

      connect {
        sidecar_service {
          tags = ["traefik.enable=false"]
          proxy {
            # Define connections to dependencies
            upstreams {
              destination_name = "immich-cache"
              local_bind_port  = 6379
            }
            upstreams {
              destination_name = "immich-db"
              local_bind_port  = 5432
            }
            upstreams {
              destination_name = "immich-ml"
              local_bind_port  = 3003
            }
          }
        }

        sidecar_task {
          resources {
            cpu = 48
            memory = 50
          }
        }
      }
    }

    # Individual task definitions
    
    task "immich-server" {
      driver = "docker"
      
      config {
        image  = "ghcr.io/immich-app/immich-server:release"
        ports = ["http"]
        image_pull_timeout = "15m"
      }

      env {
        # Update these to point to the local sidecar proxy ports
        REDIS_HOSTNAME = "127.0.0.1"
        IMMICH_MACHINE_LEARNING_URL = "http://127.0.0.1:3003"
        # Reference your .env variables or define them here
        IMMICH_MEDIA_LOCATION = "/data"
        # Default .env variable
        TZ = "Europe/Stockholm"
        PUID = 1000
        PGID = 1000
      }

      resources {
        cpu    = 2048
        memory = 2048
      }

      template {
        destination = "secrets/variables.env"
        env         = true
        perms       = 400
        data        = <<EOH
          {{- with nomadVar "nomad/jobs/immich/secrets" }}
          DB_URL=postgres://{{- .POSTGRES_USER }}:{{- .POSTGRES_PASSWORD }}@127.0.0.1:5432/{{- .POSTGRES_DB }}
          {{- end }}
        EOH
      }

      volume_mount {
        volume      = "immich-data"
        destination = "/data"
        read_only   = false
      }
    }
    
    volume "immich-data" {
      type            = "csi"
      source          = "immich-data"
      access_mode     = "multi-node-multi-writer"
      attachment_mode = "file-system"
    }
  }

  group "machine-learning" {

    network {
      mode = "bridge"
    }

    ephemeral_disk {
      size = 3000
      migrate = true
    }

    service {
      name = "immich-ml"
      port = 3003
      
      check {
        type     = "http"
        path     = "/ping"
        interval = "5s"
        timeout  = "2s"
        expose   = true
      }

      connect {
        sidecar_service {}
        sidecar_task {
          resources {
            cpu    = 48
            memory = 50
          }
        }
      }
    }

    task "immich-machine-learning" {
      driver = "docker"
      config {
        image  = "ghcr.io/immich-app/immich-machine-learning:release"
        image_pull_timeout = "15m"
        #force_pull = true
      }

      env {
        TMPDIR       = "/tmp"
        MPLCONFIGDIR = "/local/mplconfig"
        TZ = "Europe/Stockholm"
        MACHINE_LEARNING_CACHE_FOLDER    = "${NOMAD_ALLOC_DIR}/data/cache"
        MACHINE_LEARNING_MODEL_TTL       = 0 # don't unload the model cache, re-fetching slows down queries a lot
        MACHINE_LEARNING_REQUEST_THREADS = 4
        # add your models from Settings -> Machine Learning here
        MACHINE_LEARNING_PRELOAD__CLIP   = "ViT-B-16-SigLIP-256__webli"
        MACHINE_LEARNING_PRELOAD__FACIAL_RECOGNITION = "buffalo_l"
      }
      
      resources {
        memory = 2048
        cpu    = 2048
      }

      volume_mount{
        volume = "immich-cache"
        destination = "/cache"
        read_only = false
      }
    }

    volume "immich-cache" {
      type            = "csi"
      source          = "immich-cache"
      access_mode     = "single-node-writer"
      attachment_mode = "file-system"
    }
  }

  group "backend" {
    ephemeral_disk {
      size = 300
      migrate = true
    }

    network {
      mode = "bridge"
    }

    service {
      name = "immich-cache"

      task = "valkey"
      port = 6379

      # check {
      #   type     = "script"
      #   command  = "sh"
      #   args     = ["-c", "redis-cli ping || exit 1"]
      #   interval = "10s"
      #   timeout  = "2s"
      # }

      connect {
        sidecar_service {}
        sidecar_task {
          resources {
            cpu    = 256
            memory = 50
          }
        }
      }
    }

    service {
      name = "immich-db"

      task = "database"
      port = 5432
      
      # check {
      #   type     = "script"
      #   command  = "sh"
      #   args     = ["-c", "psql -U $POSTGRES_USER -d immich  -c 'SELECT 1' || exit 1"]
      #   interval = "10s"
      #   timeout  = "2s"
      # }

      connect {
        sidecar_service {}
        sidecar_task {
          resources {
            cpu    = 48
            memory = 50
          }
        }
      }
    }

    task "valkey" {
      driver = "docker"
      
      config {
        image  = "valkey/valkey:8.1"
        image_pull_timeout = "15m"
        #force_pull = true
        args = ["/local/valkey.conf"]
      }

      template {
        destination = "local/valkey.conf"
        data = <<EOH
          # save every 60 seconds if at least 100 keys have changed
          save 60 100

          dir {{ env "NOMAD_ALLOC_DIR" }}/data
          EOH
      }

      resources {
        memory = 200
        cpu    = 300
      } 
    }

    task "database" {
      driver = "docker"

      action "backup-postgres" {
        command = "/bin/sh"
        args    = ["-c", <<EOF
          pg_dumpall -U "$POSTGRES_USER" | gzip --rsyncable > /var/lib/postgresql/data/backup/backup.$(date +"%Y%m%d%H%M").sql.gz
          echo "cleaning up backup files older than 3 days ..."
          find /var/lib/postgresql/data/backup -maxdepth 1 -type f -printf '%T@ %p\n' | sort -nr | tail -n +4 | cut -d' ' -f2- | xargs -r rm --
          EOF
        ]
      }

      config {
        image  = "ghcr.io/immich-app/postgres:14-vectorchord0.4.3"
        image_pull_timeout = "15m"
        #force_pull = true
      }
      
      volume_mount {
        volume      = "immich-db"
        destination = "/var/lib/postgresql/data"
      }

      env {
        TZ = "Europe/Stockholm"
      }

      template {
        data = <<EOH
        {{ with nomadVar "nomad/jobs/immich/secrets" }}
        POSTGRES_PASSWORD     = "{{ .POSTGRES_PASSWORD }}"
        POSTGRES_USER         = "{{ .POSTGRES_USER }}"
        POSTGRES_DB           = "{{ .POSTGRES_DB }}"
        POSTGRES_INITDB_ARGS  = "--data-checksums"
        {{ end }}
        EOH
        env = true
        destination = "secrets/.env"
        perms = 400
      }

      resources {
        cpu    = 2000
        memory = 1024
      }
    }

    volume "immich-db" {
      type            = "csi"
      source          = "immich-db"
      access_mode     = "single-node-writer"
      attachment_mode = "file-system"
    }
  }
}



    