locals {
  vault = {
    name        = "vault"
    cpu_cores   = 2
    memory_mb   = 2048
    disk_size   = 32
    vlan_id     = 40
    mac_address = "00:50:56:d9:ef:58"
    description = "Hashistack Vault Server"
  }
}

resource "proxmox_virtual_environment_vm" "vault" {
  provider    = bpg-proxmox
  name        = local.vault.name
  description = local.vault.description
  node_name   = var.PVE_NODE
  started     = true
  tags        = [ "terraform","debian","hashistack" ]

  clone {
    vm_id = 9000
  }

  cpu {
    cores = local.vault.cpu_cores
  }

  memory {
    dedicated = local.vault.memory_mb
  }

  disk {
    datastore_id = var.STORAGE_POOL
    interface    = "scsi0"
    size         = local.vault.disk_size
  }

  agent {
    enabled = true
    timeout = "5m"
  }

  network_device {
    bridge      = var.VM_BRIDGE
    mac_address = local.vault.mac_address
    model       = "virtio"
    vlan_id     = local.vault.vlan_id
  }
}