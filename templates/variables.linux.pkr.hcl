# Ubuntu Specific
variable "vm_name_ubuntu" {
  type    = string
  default = "Ubuntu-20.04-Template"
}

variable "packer_password" {
  type    = string
  default = "${env("PACKER_PASSWORD")}"
  sensitive = true
}