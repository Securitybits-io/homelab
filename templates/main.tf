terraform {
    required_version = ">= 1.11.0"
    cloud { 
        organization = "Securitybits" 
        workspaces { 
            project = "Homelab"
            name = "templates" 
        }
    }

    required_providers {
        proxmox = {
            source = "bpg/proxmox"
            version = ">= 0.50.0"
        }
    }
}

provider "proxmox" {
    insecure = true
}

