resource "proxmox_vm_qemu" "gameservers-docker-01" {
    
    # VM General Settings
    target_node = "pve-node-01"
    name = "gameservers-docker-01"
    desc = "Created with Terraform"
    onboot = true
    clone = "Ubuntu-20.04-Template-100GB"
    agent = 1
    cores = 4
    sockets = 1
    cpu = "host"
    memory = 4096

    network {
        macaddr = "00:50:56:b9:ef:27"
        bridge = "vmbr0"
        model  = "virtio"
        tag = 51
    }

    disk {
        storage = "vm"
        type = "scsi"
        size = "100G"
    }
    
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