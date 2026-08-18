#Remove
variable "SSH_USER" {
    type = string
}

#Remove
variable "SSH_PASS" {
    type = string
}

variable "PVE_NODE" {
  default = "pve-node-01"
}

variable "STORAGE_POOL" {
  default = "local-lvm"
}

variable "VM_BRIDGE" {
  default = "vmbr0"
}

variable "namecheap_username" {
  type = string
}

variable "namecheap_api_user" {
  type = string
}

variable "namecheap_api_key" {
  type = string
  sensitive = true
}