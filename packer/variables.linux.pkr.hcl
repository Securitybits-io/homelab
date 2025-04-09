# Ubuntu Specific
variable "vm_name_ubuntu" {
  type    = string
  default = "Ubuntu-20.04-Template"
}

variable "SSH_USER" {
  type    = string
  default = "${env("SSH_USER")}"
}

variable "SSH_PASS" {
  type    = string
  default = "${env("SSH_PASS")}"
  sensitive = true
}