resource "proxmox_vm_qemu" "plex" {
    
    # VM General Settings
    target_node = "pve-node-01"
    name = "plex"
    desc = "Created with Terraform"

    # VM Advanced General Settings
    onboot = true 

    # VM OS Settings
    clone = "Ubuntu-22.04-Template-250GB"

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = 4
    sockets = 1
    cpu = "host"    
    
    # VM Memory Settings
    memory = 4096
    
    # VM Network Settings
    network {
        macaddr = "00:50:56:ab:dd:d1"
        bridge = "vmbr0"
        model  = "virtio"
        tag = 40
    }

    # Set the disk size corresponding to the Template size
    disk {
        storage = "vm"
        type = "scsi"
        size = "250G"
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"

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