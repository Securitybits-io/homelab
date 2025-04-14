terraform {
    required_version = ">= 1.11.0"

    cloud { 
        organization = "Securitybits" 
        workspaces { 
            project = "Homelab"
            name = "infrastructure" 
        }
    }
    required_providers {
        proxmox = {
            source = "telmate/proxmox"
            version = "3.0.1-rc6" # https://github.com/Telmate/terraform-provider-proxmox/issues/702
        }

        namecheap = {
            source = "namecheap/namecheap"
            version = ">= 2.0.0"
        }
    }
}

provider "proxmox" {
    pm_tls_insecure = true
}

provider "namecheap" {
    user_name = var.namecheap_username
    api_user = var.namecheap_api_user
    api_key = var.namecheap_api_key
}