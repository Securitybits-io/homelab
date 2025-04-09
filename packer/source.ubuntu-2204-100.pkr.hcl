source "proxmox" "ubuntu-2204-100" {
    # Connection Configuration
    proxmox_url                 = "${var.proxmox_url}"
    username                    = "${var.proxmox_user}"
    password                    = "${var.proxmox_password}"
    insecure_skip_tls_verify    = "true"
    node                        = "${var.proxmox_node}"

    # Location Configuration
    vm_name                 = "Ubuntu-22.04-Template"
    vm_id                   = "9011"

    # Hardware Configuration
    sockets                 = "${var.vm_cpu_sockets}"
    cores                   = "${var.vm_cpu_cores}"
    memory                  = "${var.vm_mem_size}"
    cpu_type                = "${var.vm_cpu_type}"

    # Boot Configuration
    boot_command = [
        "c",
        "linux /casper/vmlinuz --- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' ",
        "<enter><wait3>",
        "acpi=off",
        "<enter><wait3>",
        "initrd /casper/initrd",
        "<enter><wait5>",
        "boot",
        "<enter>"
    ]
    boot_wait              = "5s"
    
    # Http directory Configuration
    http_interface         = "${var.http_server_interface}"
    http_directory         = "ubuntu/cloud-init"

    # ISO Configuration
    iso_file                = "local:iso/ubuntu-22.04.2-live-server-amd64.iso"
    iso_checksum            = "sha256:5e38b55d57d94ff029719342357325ed3bda38fa80054f9330dc789cd2d43931"
    #iso_url                 = "https://releases.ubuntu.com/20.04/ubuntu-20.04.4-live-server-amd64.iso"
    #iso_storage_pool        = "iso-store:iso"

    # VM Configuration
    os                      = "l26"
    vga {
        type                =  "std"
        memory              =  32
    }

    network_adapters {
        model               = "${var.vm_network_adapters_model}"
        bridge              = "${var.vm_network_adapters_bridge}"
        vlan_tag            = "40"
        firewall            = true
    }

    disks {
        storage_pool      = "vm"
        storage_pool_type = "zfspool"
        type              = "scsi"
        disk_size         = "100G"
        cache_mode        = "none"
        format            = "raw"
    }

    template_name         = "Ubuntu-22.04-Template-100GB"
    template_description  = ""
    unmount_iso           = "true"
    qemu_agent            = "true"

    # Communicator Configuration
    communicator           = "ssh"
    ssh_username           = "${var.SSH_USER}"
    ssh_password           = "${var.SSH_PASS}"
    ssh_port               = 22
    ssh_handshake_attempts = "100000"
    ssh_timeout            = "1h30m"
}