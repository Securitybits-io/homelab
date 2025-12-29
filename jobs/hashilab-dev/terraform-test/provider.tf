terraform {
  cloud { 
    organization = "Securitybits" 
    workspaces { 
      project = "Homelab"
      name = "nomad" 
    } 
  }

  required_providers {
    nomad = {
      source  = "hashicorp/nomad"
      version = ">= 2.4"
    }
  }
}

provider "nomad" {
  address = "http://nomad:4646"
}