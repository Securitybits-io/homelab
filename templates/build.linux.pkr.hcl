build {
  sources = [
        "source.proxmox.ubuntu32",
        "source.proxmox.ubuntu100",
        "source.proxmox.ubuntu250"
        ]

  provisioner "shell" {
    inline = ["echo 'Packer Template Build -- Complete'"]
  }
}