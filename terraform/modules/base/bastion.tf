# Set rule from IP range
resource "outscale_public_ip" "public_ip_bastion" {
  tags {
    key   = "Name"
    value = format("%s-%s", var.prefix_name, "public_ip_bastion")
  }
  tags {
    key   = "Env"
    value = var.prefix_name
  }
}

resource "outscale_security_group" "bastion_security_group01" {
  description         = "Terraform security group for sg rule"
  security_group_name = "bastion-security-group-01"
  net_id              = outscale_net.net01.net_id
  tags {
    key   = "Name"
    value = format("%s-%s", var.prefix_name, "bastion-security-group-01")
  }
  tags {
    key   = "Env"
    value = var.prefix_name
  }
}

resource "outscale_security_group_rule" "bastion_security_group_rule01" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.bastion_security_group01.security_group_id
  from_port_range   = "22"
  to_port_range     = "22"
  ip_protocol       = "tcp"
  ip_range          = "0.0.0.0/0"
}
