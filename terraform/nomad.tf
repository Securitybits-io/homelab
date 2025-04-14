resource "proxmox_vm_qemu" "nomad" {
    
    # VM General Settings
    target_node = "pve-node-01"
    name = "nomad"
    desc = "Created with Terraform"
    tags = "terraform,linux,hashistack"
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
        macaddr = "00:50:56:d9:ef:55"
        bridge = "vmbr0"
        model  = "virtio"
        tag = 40
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
          "sleep 5"
        ]
    }
}


resource "proxmox_vm_qemu" "nomad-01" {
    
    # VM General Settings
    target_node = "pve-node-01"
    name = "nomad-01"
    desc = "Created with Terraform"
    tags = "terraform,linux,hashistack"
    onboot = true
    clone = "Ubuntu-22.04-Template-100GB"
    agent = 1
    cores = 4
    sockets = 1
    cpu_type = "host"
    memory = 8192
    skip_ipv6 = true

    network {
        id = 0
        macaddr = "00:50:56:d9:ef:57"
        bridge = "vmbr0"
        model  = "virtio"
        tag = 40
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

resource "proxmox_vm_qemu" "nomad-02" {
    
    # VM General Settings
    target_node = "pve-node-01"
    name = "nomad-02"
    desc = "Created with Terraform"
    tags = "terraform,linux,hashistack"
    onboot = true
    clone = "Ubuntu-22.04-Template-100GB"
    agent = 1
    cores = 4
    sockets = 1
    cpu_type = "host"
    memory = 8192
    skip_ipv6 = true

    network {
        id = 0
        macaddr = "00:50:56:3F:62:B4"
        bridge = "vmbr0"
        model  = "virtio"
        tag = 40
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

resource "proxmox_vm_qemu" "nomad-03" {
    
    # VM General Settings
    target_node = "pve-node-01"
    name = "nomad-03"
    desc = "Created with Terraform"
    tags = "terraform,linux,hashistack,public"
    onboot = true
    clone = "Ubuntu-22.04-Template-100GB"
    agent = 1
    cores = 4
    sockets = 1
    cpu_type = "host"
    memory = 8192
    skip_ipv6 = true

    network {
        id = 0
        macaddr = "00:50:56:6D:C7:88"
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