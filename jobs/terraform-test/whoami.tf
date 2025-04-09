resource "nomad_job" "whoami" {
  jobspec = file("${path.module}/jobs/whoami.nomad.hcl")
}