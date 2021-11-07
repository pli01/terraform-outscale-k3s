output "bastion_private_ip" {
  value = module.k3s-cluster.bastion_private_ip
}
output "bastion_public_ip" {
  value = module.k3s-cluster.bastion_public_ip
}
output "k3s_master_private_ip" {
  value = module.k3s-cluster.k3s_master_private_ip
}
