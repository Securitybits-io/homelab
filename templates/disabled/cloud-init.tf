# cloud-init.tf - This is where I store cloud-init configuration

# Source the Cloud Init Config file. NB: This file should be located 
# in the "files" directory under the directory you have your Terraform
# files in.
data "template_file" "cloud_init_test1" { 
  template  = "${file("${path.module}/templates/cloud-init.template")}"

  vars = {
    ssh_key = file("~/.ssh/id_rsa.pub")
    hostname = "cloudinit-test"
    domain = "securitybits.local"
  }
}

# Create a local copy of the file, to transfer to Proxmox.
resource "local_file" "cloud_init_test1" {
  content   = data.template_file.cloud_init_test1.rendered
  filename  = "${path.module}/files/user_data_cloud_init_test1.cfg"
}

# Transfer the file to the Proxmox Host
resource "null_resource" "cloud_init_test1" {
  connection {
    type    = "ssh"
    user    = "root"
    private_key = file("~/.ssh/id_rsa")
    host    = "pve-node-02"
  }

  provisioner "file" {
    source       = local_file.cloud_init_test1.filename
    destination  = "/var/lib/vz/snippets/cloud_init_test1.yml"
  }
}