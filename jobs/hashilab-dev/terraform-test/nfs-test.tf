resource "nomad_job" "nfs-test" {
  jobspec = file("${path.module}/jobs/nfs-test.nomad.hcl")
}