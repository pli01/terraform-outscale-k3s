output "bastion_private_ip" {
  value = module.k3s-cluster.bastion_private_ip
}
output "bastion_public_ip" {
  value = module.k3s-cluster.bastion_public_ip
}
output "bastion_vm_id" {
  value = module.k3s-cluster.bastion_vm_id
}

output "k3s_master_private_ip" {
  value = module.k3s-cluster.k3s_master_private_ip
}
output "k3s_master_vm_id" {
  value = module.k3s-cluster.k3s_master_vm_id
}

output "k3s_agent_private_ip" {
  value = module.k3s-cluster.k3s_agent_private_ip
}
output "k3s_agent_vm_id" {
  value = module.k3s-cluster.k3s_agent_vm_id
}
output "lb_dns_name" {
  value = module.k3s-cluster.lb_dns_name
}
output "lb_admin_dns_name" {
  value = module.k3s-cluster.lb_admin_dns_name
}
