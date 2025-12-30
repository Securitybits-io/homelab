job "csi-nfs" {
  datacenters = ["*"]
  type        = "system"

  group "plugin" {
    
    task "plugin" {
      driver = "docker"

      config {
        image = "registry.k8s.io/sig-storage/nfsplugin:v4.11.0"
        args = [
          "--v=5",
          "--nodeid=${attr.unique.hostname}",
          "--endpoint=unix:///csi/csi.sock",
          "--drivername=nfs.csi.k8s.io"
        ]
        privileged = true
      }
      
      env {
        TZ = "Europe/Stockholm"
      }

      csi_plugin {
        id        = "nfs"
        type      = "node"
        mount_dir = "/csi"
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
        image = "registry.k8s.io/sig-storage/nfsplugin:v4.11.0"
        args = [
          "--v=5",
          "--nodeid=${attr.unique.hostname}",
          "--endpoint=unix:///csi/csi.sock",
          "--drivername=nfs.csi.k8s.io"
        ]
      }
      
      env {
        TZ = "Europe/Stockholm"
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