variable "SSH_USER" {
    type = string
}

variable "SSH_PASS" {
    type = string
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