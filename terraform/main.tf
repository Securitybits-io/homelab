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
        # bgp-proxmox = {
        #     source = "bpg/proxmox"
        #     version = ">= 0.50.0"
        # }
        
        proxmox = {
            source = "telmate/proxmox"
            version = "3.0.2-rc01" # https://github.com/Telmate/terraform-provider-proxmox/issues/702
        }

        namecheap = {
            source = "namecheap/namecheap"
            version = ">= 2.0.0"
        }
    }
}

# provider "bgp-proxmox" {
#     insecure = true
# }

provider "proxmox" {
    pm_tls_insecure = true
    pm_minimum_permission_check = false
}


provider "namecheap" {
    user_name = var.namecheap_username
    api_user = var.namecheap_api_user
    api_key = var.namecheap_api_key
}