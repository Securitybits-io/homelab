locals {
  debian_13_image = {
    url       = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2"
    file_name = "debian-13-trixie-genericcloud-amd64.qcow2"
  }

  debian_13_template = {
    vm_id                = 9000
    name                 = "debian-13-trixie-template"
    description          = "Base Debian 13 trixie cloud-init template for Terraform"
    cpu_cores            = 1
    memory_mb            = 512
    disk_size            = 30
    network_bridge       = var.VM_BRIDGE
    cloud_init_datastore = var.STORAGE_POOL
    cloud_init_ipv4      = "dhcp"
  }
}

resource "proxmox_virtual_environment_file" "debian_13_cloud_image" {
  content_type = "import"
  datastore_id = var.FILE_STORAGE
  node_name    = var.PVE_NODE

  source_file {
    path      = local.debian_13_image.url
    file_name = local.debian_13_image.file_name
  }
}

resource "proxmox_virtual_environment_vm" "debian_13_template" {
  node_name   = var.PVE_NODE
  vm_id       = local.debian_13_template.vm_id
  name        = local.debian_13_template.name
  description = local.debian_13_template.description
  template    = true
  started     = false

  cpu {
    cores = local.debian_13_template.cpu_cores
  }

  memory {
    dedicated = local.debian_13_template.memory_mb
  }

  agent {
    enabled = true
  }

  disk {
    datastore_id = var.STORAGE_POOL
    interface    = "scsi0"
    size         = local.debian_13_template.disk_size
    file_id      = proxmox_virtual_environment_file.debian_13_cloud_image.id
  }

  initialization {
    datastore_id = local.debian_13_template.cloud_init_datastore

    ip_config {
      ipv4 {
        address = local.debian_13_template.cloud_init_ipv4
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.debian_13_template_cloud_init.id
  }

  network_device {
    bridge = local.debian_13_template.network_bridge
    model  = "virtio"
  }

  depends_on = [
    proxmox_virtual_environment_file.debian_13_cloud_image,
    proxmox_virtual_environment_file.debian_13_template_cloud_init
  ]
}
