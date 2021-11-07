module "k3s-cluster" {
  #source      = "github.com/pli01/terraform-openstack-k3s//terraform?ref=main"
  source               = "../terraform"
  image_name           = var.image_name
  keypair_name         = var.keypair_name
  bastion_count        = var.bastion_count
  bastion_type         = var.bastion_type
  ssh_authorized_keys  = var.ssh_authorized_keys
  k3s_master_install_script = var.k3s_master_install_script
  k3s_master_variables = var.k3s_master_variables
}
