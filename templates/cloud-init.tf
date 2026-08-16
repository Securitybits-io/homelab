resource "proxmox_virtual_environment_file" "debian_13_template_cloud_init" {
  content_type = "snippets"
  datastore_id = var.SNIPPET_STORAGE
  node_name    = var.PVE_NODE

  source_raw {
    file_name = "debian-13-template-cloud-init.yaml"

    data = templatefile("${path.module}/templates/ansible-bootstrap.cloud-init.tftpl", {
      ansible_user           = var.ANSIBLE_USER
      ansible_ssh_public_key = var.ANSIBLE_SSH_PUBLIC_KEY
    })
  }
}
