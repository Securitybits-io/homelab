resource "proxmox_vm_qemu" "public-docker-01" {
    
    # VM General Settings
    target_node = "pve-node-01"
    name = "public-docker-01"
    desc = "Created with Terraform"
    tags = "terraform,linux,docker"
    onboot = true
    clone = "Ubuntu-22.04-Template-100GB"
    agent = 1
    cores = 2
    sockets = 1
    cpu_type = "host"
    memory = 2048
    skip_ipv6 = true

    network {
        id = 0
        macaddr = "00:50:56:b9:ef:57"
        bridge = "vmbr0"
        model  = "virtio"
        tag = 50
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