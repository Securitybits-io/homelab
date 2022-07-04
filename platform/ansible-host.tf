resource "proxmox_vm_qemu" "ansible-host" {
    
    # VM General Settings
    target_node = "proxmox1"
    name = "ansible-host"
    desc = "Created with Terraform"

    # VM Advanced General Settings
    onboot = true 

    # VM OS Settings
    clone = "Ubuntu-20.04-Template-32GB"

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = 1
    sockets = 1
    cpu = "host"    
    
    # VM Memory Settings
    memory = 2048

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
        size = "32G"
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"
}