module "k3s-cluster" {
  #source      = "github.com/pli01/terraform-outscale-k3s//terraform?ref=main"
  source              = "../terraform"
  image_name          = var.image_name
  keypair_name        = var.keypair_name
  ssh_authorized_keys = var.ssh_authorized_keys
  bastion_count       = var.bastion_count
  bastion_type        = var.bastion_type
  k3s_master_count       = var.k3s_master_count
  k3s_master_type     = var.k3s_master_type
  #k3s_master_install_script = var.k3s_master_install_script
  k3s_master_variables     = var.k3s_master_variables
  k3s_agent_count       = var.k3s_agent_count
  k3s_agent_type           = var.k3s_agent_type
  #k3s_agent_install_script = var.k3s_agent_install_script
  k3s_agent_variables      = var.k3s_agent_variables
}
