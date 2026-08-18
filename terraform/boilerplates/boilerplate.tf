locals {
  test_vm = {
    name        = "nomad-05"
    cpu_cores   = 1
    memory_mb   = 1024
    disk_size   = 40
    vlan_id     = 40
    mac_address = "bc:24:11:bf:de:3f"
    description = "Test VM cloned from Debian 13 template"
  }
}

resource "proxmox_virtual_environment_vm" "debian_test_01" {
  provider    = bpg-proxmox
  name        = local.test_vm.name
  description = local.test_vm.description
  node_name   = var.PVE_NODE
  started     = true

  clone {
    vm_id = 9000
  }

  cpu {
    cores = local.test_vm.cpu_cores
  }

  memory {
    dedicated = local.test_vm.memory_mb
  }

  disk {
    datastore_id = var.STORAGE_POOL
    interface    = "scsi0"
    size         = local.test_vm.disk_size
  }

  agent {
    enabled = true
    timeout = "5m"
  }

  network_device {
    bridge      = var.VM_BRIDGE
    mac_address = local.test_vm.mac_address
    model       = "virtio"
    vlan_id     = local.test_vm.vlan_id
  }
}