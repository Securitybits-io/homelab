resource "proxmox_vm_qemu" "offsec-docker-01" {
    
    target_node = "pve-node-01"
    name = "offsec-docker-01"
    desc = "Created with Terraform"
    onboot = true
    clone = "Ubuntu-22.04-Template-32GB"
    agent = 1
    cores = 2
    sockets = 1
    cpu = "host"
    memory = 2048

    network {
        macaddr = "00:50:56:b9:ef:56"
        bridge = "vmbr0"
        model  = "virtio"
        tag = 40
    }

    disk {
        storage = "vm"
        type = "scsi"
        size = "100G"
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
          "sudo hostnamectl set-hostname ${self.name}"
        ]
    }

    provisioner "remote-exec" {
      inline = [
          "sudo reboot"
        ]
    }
}