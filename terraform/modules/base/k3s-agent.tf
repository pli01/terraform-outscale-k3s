resource "outscale_security_group" "k3s_agent_security_group01" {
  description         = "Terraform security group for sg rule"
  security_group_name = "k3s_agent-security-group-01"
  net_id              = outscale_net.net01.net_id
  tags {
    key   = "Name"
    value = format("%s-%s", var.prefix_name, "k3s_agent-security-group-01")
  }
  tags {
    key   = "Env"
    value = var.prefix_name
  }
}

resource "outscale_security_group_rule" "k3s_agent_security_group_rule01" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.k3s_agent_security_group01.security_group_id
  ip_protocol       = "tcp"
  from_port_range   = "22"
  to_port_range     = "22"
  ip_range          = var.network.public_subnet_cidr
}

resource "outscale_security_group_rule" "k3s_agent_security_group_rule02" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.k3s_agent_security_group01.security_group_id
  ip_protocol       = "udp"
  from_port_range   = "8472"
  to_port_range     = "8472"
  ip_range          = var.network.private_subnet_cidr
}

resource "outscale_security_group_rule" "k3s_agent_security_group_rule03" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.k3s_agent_security_group01.security_group_id
  ip_protocol       = "tcp"
  from_port_range   = "10250"
  to_port_range     = "10250"
  ip_range          = var.network.private_subnet_cidr
}

resource "outscale_security_group_rule" "k3s_agent_security_group_rule04" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.k3s_agent_security_group01.security_group_id
  ip_protocol       = "tcp"
  from_port_range   = "80"
  to_port_range     = "80"
  ip_range          = var.network.private_subnet_cidr
}

resource "outscale_security_group_rule" "k3s_agent_security_group_rule05" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.k3s_agent_security_group01.security_group_id
  ip_protocol       = "tcp"
  from_port_range   = "80"
  to_port_range     = "80"
  ip_range          = "0.0.0.0/0"
}

resource "outscale_security_group_rule" "k3s_agent_security_group_rule06" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.k3s_agent_security_group01.security_group_id
  ip_protocol       = "tcp"
  from_port_range   = "443"
  to_port_range     = "443"
  ip_range          = var.network.private_subnet_cidr
}
