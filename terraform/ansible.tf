resource "proxmox_vm_qemu" "ansible" {
    
    target_node = "pve-node-01"
    name = "ansible"
    desc = "Created with Terraform"
    onboot = true 
    clone = "Ubuntu-22.04-Template-32GB"
    agent = 1
    cores = 1
    sockets = 1
    cpu_type = "host"
    memory = 2048
    tags = "terraform,linux"

    network {
        id = 0
        macaddr = "00:50:56:b9:1e:9d"
        bridge = "vmbr0"
        model  = "virtio"
        tag = 40
    }

    disk {
        backup = false
        slot = "scsi0"
        storage = "vm"
        type = "disk"
        size = "32G"
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
          "sudo hostnamectl set-hostname ${self.name}",
          "sudo reboot"
        ]
    }
}