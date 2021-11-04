# Set rule from IP range

resource "outscale_security_group" "security_group01" {
  description         = "Terraform security group for sg rule"
  security_group_name = "security-group-01"
  net_id              = outscale_net.net01.net_id
}

resource "outscale_security_group_rule" "security_group_rule01" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.security_group01.security_group_id
  from_port_range   = "22"
  to_port_range     = "22"
  ip_protocol       = "tcp"
  ip_range          = "0.0.0.0/0"
}
