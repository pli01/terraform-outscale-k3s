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
