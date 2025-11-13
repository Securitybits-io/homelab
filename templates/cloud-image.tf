resource "proxmox_virtual_environment_file" "cloud_image" {
  # Downloads the image directly to the Proxmox host
  content_type = "import" 
  # Use your storage ID (e.g., 'local' for ISO storage)
  datastore_id = var.FILE_STORAGE
  node_name    = var.PVE_NODE

  source_file {
    path      = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
    # Ensure the downloaded file is named with the correct extension for import
    file_name = "ubuntu-jammy-cloudinit.qcow2" 
  }
}

resource "proxmox_virtual_environment_vm" "cloud_template_base" {
  node_name   = var.PVE_NODE
  vm_id       = 9000
  name        = "ci-ubuntu-jammy-server-template"
  description = "Base Cloud-init Template for Terraform"
  template    = true

  cpu { cores = 1 }
  memory { dedicated = 512 }
  agent { enabled = true }

  disk {
    datastore_id = var.STORAGE_POOL
    interface    = "scsi0"
    size         = 30
    
    file_id = proxmox_virtual_environment_file.cloud_image.id 
  }

  initialization {
    datastore_id = var.STORAGE_POOL
    ip_config { 
      ipv4 { 
        address = "192.168.0.1/24" 
      } 
    }
  }
  
  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }
  
  depends_on = [proxmox_virtual_environment_file.cloud_image]
}