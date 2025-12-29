resource "bgp_proxmox_virtual_environment_vm" "vault-01" {
  # --- VM Placement and Identification ---
  node_name = var.PVE_NODE
  vm_id     = 301 
  name      = "vault-01"
  
  # --- Hardware Resources ---
  cpu {
    cores = 1
  }
  memory {
    dedicated = 2048 # 4GB RAM
  }
  
  # Resize the disk 
  disk {
    datastore_id = var.STORAGE_POOL
    import_from = "local:import/vm-9001-disk-0"
    interface    = "scsi0"
    size         = 32
  }
  
  initialization {
    # uncomment and specify the datastore for cloud-init disk if default `local-lvm` is not available
    # datastore_id = "local-lvm"
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
    user_account {
      password = "${var.SSH_PASS}"
      username = "${var.SSH_USER}"
    }
  }
  

  # --- Network Configuration (VLAN 40) ---
  network_device {
    bridge = "vmbr0"
    model  = "virtio"
    mac_address = "de:ad:be:ef:c0:fe"
    vlan_id = 40
  }
}