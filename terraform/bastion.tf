variable "bastion_type" {
  type    = string
  default = "t2.nano"
}

variable "bastion_count" {
  type    = number
  default = 1
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
