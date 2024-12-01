resource "proxmox_vm_qemu" "nomad" {
    
    # VM General Settings
    target_node = "pve-node-01"
    name = "nomad"
    desc = "Created with Terraform"
    tags = "terraform,linux,hashistack"
    onboot = true
    clone = "Ubuntu-22.04-Template-100GB"
    agent = 1
    cores = 4
    sockets = 1
    cpu_type = "host"
    memory = 8192

    network {
        id = 0
        macaddr = "00:50:56:d9:ef:57"
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
          "sudo hostnamectl set-hostname ${self.name}"
        ]
    }
}