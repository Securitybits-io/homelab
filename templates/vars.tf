# Define key variables for easy management
variable "PVE_NODE" { default = "pve-node-01" }
variable "STORAGE_POOL" { default = "local-lvm" } # Storage for VM disk
variable "FILE_STORAGE" { default = "local" }    # Storage for the QCOW2 image
