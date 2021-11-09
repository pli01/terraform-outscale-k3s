variable "image_name" {
  type    = string
  # debian 9
  default = "ami-47899c77"
  # debian 10
  # default = "ami-ff13275d"
  # debian 11
  # default = "ami-19f1ba1c"
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
variable "k3s_master_count" {
  type    = number
  default = 1
}

variable "k3s_master_type" {
  type    = string
  default = "t2.medium"
}

#variable "k3s_master_install_script" {}

variable "k3s_master_variables" {
  type    = map(any)
  default = {}
}

variable "k3s_agent_count" {
  type    = number
  default = 1
}
variable "k3s_agent_type" {
  type    = string
  default = "t2.medium"
}

#variable "k3s_agent_install_script" {}

variable "k3s_agent_variables" {
  type    = map(any)
  default = {}
}
