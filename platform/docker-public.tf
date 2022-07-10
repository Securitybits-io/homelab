resource "proxmox_vm_qemu" "public-docker-01" {
    
    # VM General Settings
    target_node = "proxmox1"
    name = "public-docker-01"
    desc = "Created with Terraform"
    onboot = true
    clone = "Ubuntu-20.04-Template-100GB"
    agent = 1
    cores = 2
    sockets = 1
    cpu = "host"
    memory = 2048

    network {
        macaddr = "ce:9a:38:1a:a5:63"
        bridge = "vmbr0"
        model  = "virtio"
        tag = 50
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