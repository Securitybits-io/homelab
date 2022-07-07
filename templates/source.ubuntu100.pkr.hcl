source "proxmox" "ubuntu100" {
    # Connection Configuration
    proxmox_url             = "${var.proxmox_url}"
    username                = "${var.proxmox_user}"
    password                = "${var.proxmox_password}"
    insecure_skip_tls_verify    = "true"
    node                    = "${var.proxmox_node}"

    # Location Configuration
    vm_name                 = "${var.vm_name_ubuntu}"
    vm_id                   = "9001"

    # Hardware Configuration
    sockets                 = "${var.vm_cpu_sockets}"
    cores                   = "${var.vm_cpu_cores}"
    memory                  = "${var.vm_mem_size}"
    cpu_type                = "${var.vm_cpu_type}"

    # Boot Configuration
    boot_command           = ["<enter><enter><f6><esc><wait> ", "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/", "<enter>"]
    boot_wait              = "5s"
    
    # Http directory Configuration
    http_interface         = "${var.http_server_interface}"
    http_directory         = "ubuntu/cloud-init"

    # ISO Configuration
    iso_file                = "local:iso/ubuntu-20.04.4-live-server-amd64.iso"
    iso_checksum            = "sha256:28ccdb56450e643bad03bb7bcf7507ce3d8d90e8bf09e38f6bd9ac298a98eaad"
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

    template_name         = "${var.vm_name_ubuntu}-100GB"
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