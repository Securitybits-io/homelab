resource "proxmox_vm_qemu" "elastic-breachsearch-hot-01" {
    
    # VM General Settings
    target_node = "pve-node-01"
    name = "elastic-breachsearch-hot-01"
    desc = "Created with Terraform"

    # VM Advanced General Settings
    onboot = true 

    # VM OS Settings
    clone = "Ubuntu-22.04-Template-250GB"

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = 2
    sockets = 2
    cpu_type = "host"    
    
    # VM Memory Settings
    memory = 4096
    
    # VM Network Settings
    network {
        macaddr = "00:50:56:ab:dd:b1"
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
      script_path = "/home/${var.SSH_USER}/provision_%RAND%.sh"
    }

    provisioner "remote-exec" {
      inline = [
          "sleep 20",
          "sudo hostnamectl set-hostname ${self.name}",
          "(sleep 5; sudo reboot) &",
          "exit 0"
      ]
    }
}

resource "proxmox_vm_qemu" "elastic-breachsearch-hot-02" {
    
    # VM General Settings
    target_node = "pve-node-01"
    name = "elastic-breachsearch-hot-02"
    desc = "Created with Terraform"

    # VM Advanced General Settings
    onboot = true 

    # VM OS Settings
    clone = "Ubuntu-22.04-Template-250GB"

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = 2
    sockets = 2
    cpu_type = "host"    
    
    # VM Memory Settings
    memory = 4096
    
    # VM Network Settings
    network {
        macaddr = "00:50:56:ab:dd:b2"
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
      script_path = "/home/${var.SSH_USER}/provision_%RAND%.sh"
    }

    provisioner "remote-exec" {
      inline = [
          "sleep 20",
          "sudo hostnamectl set-hostname ${self.name}",
          "(sleep 5; sudo reboot) &",
          "exit 0"
      ]
    }
}

resource "proxmox_vm_qemu" "elastic-breachsearch-hot-03" {
    
    # VM General Settings
    target_node = "pve-node-01"
    name = "elastic-breachsearch-hot-03"
    desc = "Created with Terraform"

    # VM Advanced General Settings
    onboot = true 

    # VM OS Settings
    clone = "Ubuntu-22.04-Template-250GB"

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = 2
    sockets = 2
    cpu_type = "host"    
    
    # VM Memory Settings
    memory = 4096
    
    # VM Network Settings
    network {
        macaddr = "00:50:56:ab:dd:b3"
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
      script_path = "/home/${var.SSH_USER}/provision_%RAND%.sh"
    }

    provisioner "remote-exec" {
      inline = [
          "sleep 20",
          "sudo hostnamectl set-hostname ${self.name}",
          "(sleep 5; sudo reboot) &",
          "exit 0"
      ]
    }
}

resource "proxmox_vm_qemu" "elastic-breachsearch-kibana-01" {
    
    # VM General Settings
    target_node = "pve-node-01"
    name = "elastic-breachsearch-kibana-01"
    desc = "Created with Terraform"

    # VM Advanced General Settings
    onboot = true 

    # VM OS Settings
    clone = "Ubuntu-22.04-Template-32GB"

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = 1
    sockets = 1
    cpu_type = "host"    
    
    # VM Memory Settings
    memory = 2048
    
    # VM Network Settings
    network {
        macaddr = "00:50:56:ab:dd:b9"
        bridge = "vmbr0"
        model  = "virtio"
        tag = 40
    }

    # Set the disk size corresponding to the Template size
    disk {
        storage = "vm"
        type = "scsi"
        size = "32G"
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"

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
          "sudo hostnamectl set-hostname ${self.name}",
          "(sleep 5; sudo reboot) &",
          "exit 0"
      ]
    }
}

resource "proxmox_vm_qemu" "elastic-breachsearch-logstash" {
    
    # VM General Settings
    target_node = "pve-node-01"
    name = "elastic-breachsearch-logstash"
    desc = "Created with Terraform"

    # VM Advanced General Settings
    onboot = true 

    # VM OS Settings
    clone = "Ubuntu-22.04-Template-32GB"

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = 1
    sockets = 2
    cpu_type = "host"    
    
    # VM Memory Settings
    memory = 1024
    
    # VM Network Settings
    network {
        macaddr = "00:50:56:ab:dd:b8"
        bridge = "vmbr0"
        model  = "virtio"
        tag = 40
    }

    # Set the disk size corresponding to the Template size
    disk {
        storage = "vm"
        type = "scsi"
        size = "32G"
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"

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
          "sudo hostnamectl set-hostname ${self.name}",
          "(sleep 5; sudo reboot) &",
          "exit 0"
      ]
    }
}