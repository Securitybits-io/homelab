# resource "nomad_job" "whoami" {
#   jobspec = file("${path.module}/jobs/whoami.nomad.hcl")
# }

resource "nomad_csi_volume" "test_volume" {
  plugin_id    = "nfs"
  volume_id    = "test-volume" # The ID from your cloud provider
  name         = "test-data"

  capability {
    access_mode     = "multi-node-multi-writer"
    attachment_mode = "file-system"
  }

  parameters = {
    server = "10.0.11.241"
    share = "/Securitybits.Systems/Jellyfin"
    subDir = "Config"
  }

  mount_options {
    fs_type     = "nfs"
    mount_flags = [ "nolock", "soft", "async", "nfsvers=3" ]
  }
}