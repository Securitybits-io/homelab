locals {
  plex = {
    name        = "plex"
    cpu_cores   = 4
    memory_mb   = 4096
    disk_size   = 350
    vlan_id     = 40
    mac_address = "00:50:56:ab:dd:d1"
    description = "Plex Media Server"
  }
}

resource "proxmox_virtual_environment_vm" "plex" {
  provider    = bpg-proxmox
  name        = local.plex.name
  description = local.plex.description
  node_name   = var.PVE_NODE
  started     = true
  tags        = [ "terraform","debian" ]

  clone {
    vm_id = 9000
  }

  cpu {
    cores = local.plex.cpu_cores
  }

  memory {
    dedicated = local.plex.memory_mb
  }

  disk {
    datastore_id = var.STORAGE_POOL
    interface    = "scsi0"
    size         = local.plex.disk_size
  }

  agent {
    enabled = true
    timeout = "5m"
  }

  network_device {
    bridge      = var.VM_BRIDGE
    mac_address = local.plex.mac_address
    model       = "virtio"
    vlan_id     = local.plex.vlan_id
  }
}