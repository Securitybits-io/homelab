resource "proxmox_vm_qemu" "takserver" {
    
    # VM General Settings
    target_node = "pve-node-01"
    name = "takserver"
    desc = "Created with Terraform"
    onboot = true
    clone = "Ubuntu-22.04-Template-100GB"
    agent = 1
    cores = 4
    sockets = 1
    cpu_type = "host"
    memory = 8192

    network {
        macaddr = "00:50:56:b9:ef:16"
        bridge = "vmbr0"
        model  = "virtio"
        tag = 51
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
          "sleep 20",
          "sudo hostnamectl set-hostname ${self.name}"
        ]
    }

    provisioner "remote-exec" {
      inline = [
          "(sudo sleep 10; reboot ) &"
        ]
    }
}