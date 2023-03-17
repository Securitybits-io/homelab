resource "proxmox_vm_qemu" "takserver" {
    
    # VM General Settings
    target_node = "pve-node-01"
    name = "takserver"
    desc = "Created with Terraform"
    onboot = true
    clone = "Ubuntu-20.04-Template-100GB"
    agent = 1
    cores = 2
    sockets = 1
    cpu = "host"
    memory = 2048

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