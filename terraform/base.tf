# base ressources (vpc,network,security group)

variable "network" {
  default = {
    net_cidr            = "10.0.0.0/16"
    public_subnet_cidr  = "10.0.1.0/24"
    private_subnet_cidr = "10.0.2.0/24"
  }
}

module "base" {
  source      = "./modules/base"
  prefix_name = var.prefix_name
  network     = var.network
}

output "bastion_security_group_id" {
  value = module.base.bastion_security_group_id
}

output "bastion_public_ip" {
  value = module.base.bastion_public_ip
}
