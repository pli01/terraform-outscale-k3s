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
variable "docker_version" {
  default = ""
}
variable "docker_compose_version" {
  default = ""
}


module "bastion" {
  source                 = "./modules/bastion"
  maxcount               = var.bastion_count
  image_id               = var.image_name
  vm_type                = var.bastion_type
  keypair_name           = var.keypair_name
  public_ip              = module.base.bastion_public_ip
  subnet_id              = module.base.public_subnet_id
  security_group_ids     = [module.base.bastion_security_group_id]
  docker_version         = var.docker_version
  docker_compose_version = var.docker_compose_version
  ssh_authorized_keys    = var.ssh_authorized_keys
  depends_on = [
    module.base
  ]
}

locals {
  bastion_private_ip = flatten(module.bastion[*].private_ip)
}

output "bastion_private_ip" {
  value = local.bastion_private_ip
}
