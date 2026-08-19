locals {
  private_ytdl = {
    name        = "private-ytdl"
    cpu_cores   = 1
    memory_mb   = 1024
    disk_size   = 32
    vlan_id     = 160
    mac_address = "00:50:56:b9:ef:62"
    description = "Created with Terraform"
  }
}

resource "proxmox_virtual_environment_vm" "private_ytdl" {
  provider    = bpg-proxmox
  name        = local.private_ytdl.name
  description = local.private_ytdl.description
  node_name   = var.PVE_NODE
  started     = true
  tags        = [ "terraform","debian" ]

  clone {
    vm_id = 9000
  }

  cpu {
    cores = local.private_ytdl.cpu_cores
  }

  memory {
    dedicated = local.private_ytdl.memory_mb
  }

  disk {
    datastore_id = var.STORAGE_POOL
    interface    = "scsi0"
    size         = local.private_ytdl.disk_size
  }

  agent {
    enabled = true
    timeout = "5m"
  }

  network_device {
    bridge      = var.VM_BRIDGE
    mac_address = local.private_ytdl.mac_address
    model       = "virtio"
    vlan_id     = local.private_ytdl.vlan_id
  }
}

resource "proxmox_vm_qemu" "private-docker-01" {
    
    # VM General Settings
    target_node = "pve-node-01"
    name = "private-docker-01"
    desc = "Created with Terraform"
    tags = "terraform,linux,docker"
    onboot = true
    clone = "Ubuntu-22.04-Template-100GB"
    agent = 1
    cores = 4
    sockets = 1
    cpu_type = "host"
    memory = 4096
    skip_ipv6 = true

    network {
        id = 0
        macaddr = "00:50:56:b9:ef:60"
        bridge = "vmbr0"
        model  = "virtio"
        tag = 160
    }

    disk {
        storage = "vm"
        slot = "scsi0"
        type = "disk"
        size = "100G"
        format = "raw"
    }

    #os_type = "cloud-init"
    connection {
      type      = "ssh"
      user      = var.SSH_USER
      password  = var.SSH_PASS
      host      = self.ssh_host
      script_path = "/home/${var.SSH_USER}/provision_%RAND%.sh"
    }

    provisioner "remote-exec" {
      inline = [
          "sleep 10",
          "sudo hostnamectl set-hostname ${self.name}",
          "sudo reboot"
        ]
    }
}
