# application stack
variable "k3s_agent_name" {
  default = "k3s-agent"
}
variable "k3s_agent_count" {
  type    = number
  default = 1
}
variable "k3s_agent_type" {
  type    = string
  default = "t2.medium"
}
variable "k3s_agent_install_script" {
  default = "https://raw.githubusercontent.com/pli01/terraform-outscale-k3s/main/samples/app/k3s/k3s-agent-install.sh"
}
variable "k3s_agent_variables" {
  type    = map(any)
  default = {}
}

module "k3s-agent" {
  source                   = "./modules/app"
  prefix_name              = var.prefix_name
  maxcount                 = var.k3s_agent_count
  app_name                 = var.k3s_agent_name
  vm_type                  = var.k3s_agent_type
  image_id                 = var.image_name
  keypair_name             = var.keypair_name
  subnet_id                = module.base.private_subnet_id
  security_group_ids       = [module.base.k3s_agent_security_group_id]
  ssh_authorized_keys      = var.ssh_authorized_keys
  docker_version           = var.docker_version
  docker_compose_version   = var.docker_compose_version
  dockerhub_login          = var.dockerhub_login
  dockerhub_token          = var.dockerhub_token
  github_token             = var.github_token
  docker_registry_username = var.docker_registry_username
  docker_registry_token    = var.docker_registry_token
  app_install_script       = var.k3s_agent_install_script
  app_variables            = merge({ K3S_URL = format("https://%s:6443", join("", local.k3s_master_private_ip)) }, var.k3s_agent_variables)
  depends_on = [
    module.base,
    module.bastion,
    module.k3s-master
  ]
}

# output
locals {
  k3s_agent_private_ip = flatten(module.k3s-agent[*].private_ip)
  k3s_agent_vm_id = flatten(module.k3s-agent[*].vm_id)
}

output "k3s_agent_private_ip" {
  value = local.k3s_agent_private_ip
}
output "k3s_agent_vm_id" {
  value = local.k3s_agent_vm_id
}
