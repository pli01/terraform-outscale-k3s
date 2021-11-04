module "k3s-cluster" {
  #source      = "github.com/pli01/terraform-openstack-k3s//terraform?ref=main"
  source       = "../terraform"
  image_name   = var.image_name
  keypair_name = var.keypair_name
  vm_type      = var.vm_type
}
