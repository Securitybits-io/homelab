resource "proxmox_vm_qemu" "nginx" {
    
    # VM General Settings
    target_node = "pve-node-01"
    name = "nginx"
    desc = "Created with Terraform"

    # VM Advanced General Settings
    onboot = true 

    # VM OS Settings
    clone = "Ubuntu-22.04-Template-32GB"

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = 1
    sockets = 1
    cpu = "host"    
    
    # VM Memory Settings
    memory = 1024
    
    # VM Network Settings
    network {
        macaddr = "00:05:56:1A:BD:BE"
        bridge = "vmbr0"
        model  = "virtio"
        tag = 50
    }

    # Set the disk size corresponding to the Template size
    disk {
        storage = "vm"
        type = "scsi"
        size = "32G"
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
          "sudo hostnamectl set-hostname ${self.name}",
          "sudo reboot"
        ]
    }
}