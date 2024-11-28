resource "proxmox_vm_qemu" "plex" {
    
    # VM General Settings
    target_node = "pve-node-01"
    name = "plex"
    desc = "Created with Terraform"
    tags = "terraform,linux"

    # VM Advanced General Settings
    onboot = true 

    # VM OS Settings
    clone = "Ubuntu-22.04-Template-250GB"

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = 4
    sockets = 1
    cpu_type = "host"    
    
    # VM Memory Settings
    memory = 4096
    
    # VM Network Settings
    network {
        id = 0
        macaddr = "00:50:56:ab:dd:d1"
        bridge = "vmbr0"
        model  = "virtio"
        tag = 40
    }

    # Set the disk size corresponding to the Template size
    disk {
        storage = "vm"
        slot = "scsi0"
        type = "disk"
        size = "250G"
        format = "raw"
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"

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
          "sudo hostnamectl set-hostname ${self.name}"
        ]
    }
}