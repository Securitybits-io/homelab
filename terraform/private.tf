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

resource "proxmox_vm_qemu" "private-ytdl" {
    
    # VM General Settings
    target_node = "pve-node-01"
    name = "private-ytdl"
    desc = "Created with Terraform"
    tags = "terraform,linux"

    # VM Advanced General Settings
    onboot = true 
    skip_ipv6 = true

    # VM OS Settings
    clone = "Ubuntu-22.04-Template-32GB"

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = 1
    sockets = 1
    cpu_type = "host"    
    
    # VM Memory Settings
    memory = 1024
    
    # VM Network Settings
    network {
        id = 0
        macaddr = "00:50:56:b9:ef:62"
        bridge = "vmbr0"
        model  = "virtio"
        tag = 160
    }

    # Set the disk size corresponding to the Template size
    disk {
        storage = "vm"
        slot = "scsi0"
        type = "disk"
        size = "32G"
        format = "raw"
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"

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