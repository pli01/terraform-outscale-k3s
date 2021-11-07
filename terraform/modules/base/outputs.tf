output "public_subnet_id" {
  value = outscale_subnet.public_subnet01.subnet_id
}
output "private_subnet_id" {
  value = outscale_subnet.private_subnet02.subnet_id
}
output "bastion_public_ip" {
  value = outscale_public_ip.public_ip_bastion.public_ip
}
output "bastion_security_group_id" {
  value = outscale_security_group.bastion_security_group01.security_group_id
}

output "k3s_master_security_group_id" {
  value = outscale_security_group.k3s_master_security_group01.security_group_id
}
