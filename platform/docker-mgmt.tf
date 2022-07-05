resource "proxmox_vm_qemu" "mgmt-docker-01" {
    
    # VM General Settings
    target_node = "proxmox1"
    name = "mgmt-docker-01"
    desc = "Created with Terraform"
    onboot = true 
    clone = "Ubuntu-20.04-Template-100GB"
    agent = 1
    cores = 2
    sockets = 1
    cpu = "host"    
    memory = 2048
    
    network {
        macaddr = "ee:95:66:f2:ca:3e"
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
    }

    provisioner "remote-exec" {
      inline = [
          "sudo hostnamectl set-hostname ${self.name}",
          "sudo /usr/sbin/shutdown -r 1"
        ]
    }
}