job "csi-nfs" {
  datacenters = ["*"]
  type        = "system"

  group "plugin" {
    
    task "plugin" {
      driver = "docker"

      config {
        image = "registry.k8s.io/sig-storage/nfsplugin:v${IMAGE_TAG}"
        args = [
          "--v=5",
          "--nodeid=${attr.unique.hostname}",
          "--endpoint=unix:///csi/csi.sock",
          "--drivername=nfs.csi.k8s.io"
        ]
        privileged = true
      }

      csi_plugin {
        id        = "nfs"
        type      = "node"
        mount_dir = "/csi"
      }
      
      template {
        data = <<EOH
        {{ with nomadVar "nomad/jobs/csi-nfs/plugin" }}
          IMAGE_TAG="{{ .IMAGE_TAG }}"
          TZ = "Europe/Stockholm"
        {{ end }}
        EOH

        destination = "local/run.env"
        env         = true
      }

      resources {
        memory = 64
        cpu    = 100
      }
    }
  }

  group "controller" {
    
    constraint {
      attribute = "${node.datacenter}"
      value = "dc"
    }

    task "controller" {
      driver = "docker"

      config {
        image = "registry.k8s.io/sig-storage/nfsplugin:v${IMAGE_TAG}"
        args = [
          "--v=5",
          "--nodeid=${attr.unique.hostname}",
          "--endpoint=unix:///csi/csi.sock",
          "--drivername=nfs.csi.k8s.io"
        ]
      }
      
      template {
        data = <<EOH
        {{ with nomadVar "nomad/jobs/csi-nfs/controller" }}
          IMAGE_TAG="{{ .IMAGE_TAG }}"
          TZ = "Europe/Stockholm"
        {{ end }}
        EOH

        destination = "local/run.env"
        env         = true
      }

      csi_plugin {
        id        = "nfs"
        type      = "controller"
        mount_dir = "/csi"
      }

      resources {
        memory = 64
        cpu    = 100
      }
    }
  }
}