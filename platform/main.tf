terraform {
    required_version = ">= 0.13.0"

    required_providers {
        proxmox = {
            source = "telmate/proxmox"
            version = "2.9.3"
        }

        namecheap = {
            source = "namecheap/namecheap"
            version = ">= 2.0.0"
        }
    }
}

provider "proxmox" {
    pm_tls_insecure = true
    pm_parallel = 3
}

provider "namecheap" {
    user_name = var.namecheap_username
    api_user = var.namecheap_api_user
    api_key = var.namecheap_api_key
}