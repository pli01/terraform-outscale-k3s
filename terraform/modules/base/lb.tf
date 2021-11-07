resource "outscale_security_group" "lb_security_group01" {
  description         = "Terraform security group for sg rule"
  security_group_name = "lb-security-group-01"
  net_id              = outscale_net.net01.net_id
}

resource "outscale_security_group_rule" "lb_security_group_rule01" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.lb_security_group01.security_group_id
  ip_protocol       = "tcp"
  from_port_range   = "80"
  to_port_range     = "80"
  ip_range          = "0.0.0.0/0"
}
