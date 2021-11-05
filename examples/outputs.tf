output "bastion_private_ip" {
  value = module.k3s-cluster.bastion_private_ip
}
output "bastion_public_ip" {
  value = module.k3s-cluster.bastion_public_ip
}
