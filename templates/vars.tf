variable "PVE_NODE" {
  default = "pve-node-01"
}

variable "STORAGE_POOL" {
  default = "local-lvm"
}

variable "FILE_STORAGE" {
  default = "local"
}

variable "SNIPPET_STORAGE" {
  default = "local"
}

variable "VM_BRIDGE" {
  default = "vmbr0"
}

variable "ANSIBLE_USER" {
  default = "root"
}

variable "ANSIBLE_SSH_PUBLIC_KEY" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCiuk/CSB3//1AH1QWaDOoZzeaxIEn9LfXP41vrKtqRrV1fiHRfYSul2C8M9ReJyHWGasHhEf57Mf+9Hrdg4Kdi+aIgqh4m5SfarMmSfO4LL1SBUBoopr/egClDQAy9hNKTdSC1IjVxOQKZzJGMFJ26aKkHgiQGT2hPVB1p+YbcYgsQmAQgZ763IVkHyeYwuSnSijQRNwbj/etqyp4hpyAFQ11rqczqO385AuZERxagvb39Gp0N334mg4ASitgmssNeAKBSVbACXDN62eXekX1B+UBIPDJ1e7X1ViyyQXidD5DRHM/4XF2i/XWvGWwgMo4DfNaFVvjy5hQorvvnmcJO/8RDIcAKviw/PIY729+Ci7AZ8YOEOD3QeB8swaZjyn/+MNFaYiXY2z7kat3Ut4GWDxdKMMxFaDrSB0vnnNIvxNidZ/nI5TPrTBa9H3FkrJCYcq2e8oOv1cmqcYRw+Xt9UuDZL+wyTUUpvaAM3ABJW1CkmsLy7mMh9mlBVrEcKls= root@ansible"
}
