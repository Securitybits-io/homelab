resource "nomad_job" "whoami" {
  jobspec = file("${path.module}/jobs/whoami.nomad.hcl")
}

data "nomad_volumes" "whoami-volume" {
  type = "host"
  volumes = {
    
  }
  
}