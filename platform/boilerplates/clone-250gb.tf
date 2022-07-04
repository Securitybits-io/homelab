resource "proxmox_vm_qemu" "host250GB" {
    
    # VM General Settings
    target_node = "proxmox1"
    name = "name"
    desc = "Created with Terraform"

    # VM Advanced General Settings
    onboot = true 

    # VM OS Settings
    clone = "Ubuntu-20.04-Template-250GB"

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = 1
    sockets = 1
    cpu = "host"    
    
    # VM Memory Settings
    memory = 1024
    
    # VM Network Settings
    network {
        macaddr = "DE:AD:BE:EF:C0:FE"
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

    # (Optional) IP Address and Gateway
    # ipconfig0 = "ip=0.0.0.0/0,gw=0.0.0.0"
    
    # (Optional) Default User
    # ciuser = "christoffer"
    
    # (Optional) Add your SSH KEY
    # sshkeys = <<EOF
    # #PUB SSH KEY
    # EOF
}