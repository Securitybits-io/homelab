build {
  sources = [
        "source.proxmox.ubuntu-2204-32",
        "source.proxmox.ubuntu-2204-100",
        "source.proxmox.ubuntu-2204-250"
        # "source.proxmox.ubuntu32",
        # "source.proxmox.ubuntu100",
        # "source.proxmox.ubuntu250"
        ]

  provisioner "shell" {
    inline = ["echo 'Packer Template Build -- Complete'"]
  }
}