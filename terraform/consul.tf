locals {
  consul = {
    name        = "consul"
    cpu_cores   = 2
    memory_mb   = 2048
    disk_size   = 40
    vlan_id     = 40
    mac_address = "00:50:56:d9:ef:59"
    description = "Hashistack Consul Server"
  }
}

resource "proxmox_virtual_environment_vm" "consul" {
  provider    = bpg-proxmox
  name        = local.consul.name
  description = local.consul.description
  node_name   = var.PVE_NODE
  started     = true
  tags        = [ "terraform","debian","hashistack" ]

  clone {
    vm_id = 9000
  }

  cpu {
    cores = local.consul.cpu_cores
  }

  memory {
    dedicated = local.consul.memory_mb
  }

  disk {
    datastore_id = var.STORAGE_POOL
    interface    = "scsi0"
    size         = local.consul.disk_size
  }

  agent {
    enabled = true
    timeout = "5m"
  }

  network_device {
    bridge      = var.VM_BRIDGE
    mac_address = local.consul.mac_address
    model       = "virtio"
    vlan_id     = local.consul.vlan_id
  }
}