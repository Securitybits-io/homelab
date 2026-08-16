resource "proxmox_virtual_environment_file" "debian_13_cloud_image" {
  content_type = "import"
  datastore_id = var.FILE_STORAGE
  node_name    = var.PVE_NODE

  source_file {
    path      = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2"
    file_name = "debian-13-trixie-genericcloud-amd64.qcow2"
  }
}

resource "proxmox_virtual_environment_vm" "debian_13_template" {
  node_name   = var.PVE_NODE
  vm_id       = 9000
  name        = "debian-13-trixie-template"
  description = "Base Debian 13 trixie cloud-init template for Terraform"
  template    = true
  started     = false

  cpu {
    cores = 1
  }

  memory {
    dedicated = 512
  }

  agent {
    enabled = true
  }

  disk {
    datastore_id = var.STORAGE_POOL
    interface    = "scsi0"
    size         = 30
    file_id      = proxmox_virtual_environment_file.debian_13_cloud_image.id
  }

  initialization {
    datastore_id = var.STORAGE_POOL

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.debian_13_template_cloud_init.id
  }

  network_device {
    bridge = var.VM_BRIDGE
    model  = "virtio"
  }

  depends_on = [
    proxmox_virtual_environment_file.debian_13_cloud_image,
    proxmox_virtual_environment_file.debian_13_template_cloud_init
  ]
}
