variable "image_name" {
  type    = string
  default = "ami-ff13275d"
}

variable "bastion_type" {
  type    = string
  default = "t2.nano"
}

variable "keypair_name" {
  type = string
}

variable "bastion_count" {
  type    = number
  default = 1
}
variable "ssh_authorized_keys" {
  type    = list(string)
  default = []
}

