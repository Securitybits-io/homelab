terraform {
    required_version = ">= 0.13.0"

    required_providers {
        proxmox = {
            source = "telmate/proxmox"
            version = "2.9.3"
        }
    }
}

provider "proxmox" {
    pm_tls_insecure = true
}