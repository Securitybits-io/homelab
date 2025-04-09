terraform {
  backend "remote" { 
    organization = "Securitybits" 
    workspaces { 
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