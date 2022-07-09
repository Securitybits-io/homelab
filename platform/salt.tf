resource "proxmox_vm_qemu" "salt" {
    
    # VM General Settings
    target_node = "proxmox1"
    name = "salt"
    desc = "Created with Terraform"

    # VM Advanced General Settings
    onboot = true 

    # VM OS Settings
    clone = "Ubuntu-20.04-Template-32GB"

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = 1
    sockets = 1
    cpu = "host"

    # VM Memory Settings
    memory = 2048

    # VM Network Settings
    network {
        macaddr = "00:50:56:b9:1e:9c"
        bridge = "vmbr0"
        model  = "virtio"
        tag = 40
    }

    # Set the disk size corresponding to the Template size
    disk {
        storage = "vm"
        type = "scsi"
        size = "32G"
    }

    # VM Cloud-Init Settings
    #os_type = "cloud-init"

    connection {
      type      = "ssh"
      user      = var.SSH_USER
      password  = var.SSH_PASS
      host      = self.ssh_host
      script_path = "/home/${var.SSH_USER}/provision_salt-minion_%RAND%.sh"
    }

    provisioner "remote-exec" {
      inline = [
          "sudo hostnamectl set-hostname ${self.name}",
          "curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io",
          "chmod +x bootstrap-salt.sh",
          "sudo ./bootstrap-salt.sh -I -i ${self.name} -A salt.securitybits.local"
        ]
    }

    provisioner "remote-exec" {
      inline = [
          "sudo /usr/sbin/shutdown -r 1"
        ]
    }
}   