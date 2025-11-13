
resource "proxmox_vm_qemu" "cloudinit-test" {
    name = "cloudinit-test"
    depends_on = [ null_resource.cloud_init_test1 ]
    target_node = "pve-node-02"

    clone = "debian12-cloudinit"
    # Activate QEMU agent for this VM
    agent = 1

    os_type = "cloud-init"
    cores = 2
    sockets = 1
    cpu_type = "host"
    memory = 2048
    scsihw = "virtio-scsi-single"

    # Setup the disk
    disks {
        ide {
            ide2 {
                cloudinit {
                    storage = "local-lvm"
                }
            }
        }
        scsi {
            scsi0 {
                disk {
                  size     = "32G"
                  storage  = "local-lvm"
                  discard  = true
                  iothread = true
                }
            }
        }
    }

    network {
      id = 0
      model = "virtio"
      bridge = "vmbr0"
      tag = 40
    }

    # Setup the ip address using cloud-init.
    boot = "order=scsi0"
    ipconfig0 = "ip=10.0.40.230/24,gw=10.0.40.1,ip6=dhcp"
    # lifecycle {
    #   ignore_changes = [
    #     ciuser,
    #     sshkeys,
    #     network
    #   ]
    # }
    cicustom = "user=local:snippets/cloud_init_test1.yml"
}