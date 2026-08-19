

locals {
  nomad_vms = {
    nomad = {
        name        = "nomad"
        cpu_cores   = 2
        memory_mb   = 2048
        disk_size   = 40
        vlan_id     = 40
        mac_address = "00:50:56:d9:ef:55"
        description = "Hashistack Nomad Server"
        tags        = ["terraform", "debian", "hashistack"]
    }

    nomad-01 = {
        name        = "nomad-01"
        cpu_cores   = 4
        memory_mb   = 12288
        disk_size   = 100
        vlan_id     = 40
        mac_address = "00:50:56:d9:ef:57"
        description = "Hashistack Nomad Server"
        tags        = ["terraform", "debian", "hashistack"]
    }
    
    nomad-02 = {
        name        = "nomad-02"
        cpu_cores   = 4
        memory_mb   = 12288
        disk_size   = 100
        vlan_id     = 40
        mac_address = "00:50:56:3F:62:B4"
        description = "Hashistack Nomad Server"
        tags        = ["terraform", "debian", "hashistack"]
    }
    
    nomad-03 = {
        name        = "nomad-03"
        cpu_cores   = 4
        memory_mb   = 12288
        disk_size   = 100
        vlan_id     = 50
        mac_address = "00:50:56:6D:C7:88"
        description = "Hashistack Nomad Server"
        tags        = ["terraform", "debian", "hashistack", "public"]
    }
  }
}

resource "proxmox_virtual_environment_vm" "nomad" {
  provider = bpg-proxmox
  for_each = local.nomad_vms

  name        = each.key
  description = each.value.description
  node_name   = var.PVE_NODE
  started     = true
  tags        = each.value.tags

  clone {
    vm_id = 9000
  }

  cpu {
    cores = each.value.cpu_cores
  }

  memory {
    dedicated = each.value.memory_mb
  }

  disk {
    datastore_id = var.STORAGE_POOL
    interface    = "scsi0"
    size         = each.value.disk_size
  }

  agent {
    enabled = true
    timeout = "5m"
  }

  network_device {
    bridge      = var.VM_BRIDGE
    mac_address = each.value.mac_address
    model       = "virtio"
    vlan_id     = each.value.vlan_id
  }
}

