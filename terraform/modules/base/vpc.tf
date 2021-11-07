variable "network" {
  type = object({
         net_cidr = string
         public_subnet_cidr = string
         private_subnet_cidr = string
       }
  )
  default = {
    net_cidr = "10.0.0.0/16"
    public_subnet_cidr = "10.0.1.0/24"
    private_subnet_cidr = "10.0.2.0/24"
  }
}

resource "outscale_net" "net01" {
  ip_range = var.network.net_cidr
  tags {
    key   = "Name"
    value = "net01"
  }
}

# public subnet
resource "outscale_subnet" "public_subnet01" {
  net_id   = outscale_net.net01.net_id
  ip_range = var.network.public_subnet_cidr
  tags {
    key   = "Name"
    value = "public_subnet01"
  }
}

# private subnet
resource "outscale_subnet" "private_subnet02" {
  net_id   = outscale_net.net01.net_id
  ip_range = var.network.private_subnet_cidr
  tags {
    key   = "Name"
    value = "private_subnet02"
  }
}

# igw
resource "outscale_route_table" "route_table01" {
  net_id = outscale_net.net01.net_id
  tags {
    key   = "Name"
    value = "route_table01"
  }
}

resource "outscale_route" "route01" {
  destination_ip_range = "0.0.0.0/0"
  gateway_id           = outscale_internet_service.internet_service01.internet_service_id
  route_table_id       = outscale_route_table.route_table01.route_table_id
}

resource "outscale_route_table_link" "route_table_link01" {
  subnet_id      = outscale_subnet.public_subnet01.subnet_id
  route_table_id = outscale_route_table.route_table01.id
}

resource "outscale_internet_service" "internet_service01" {
  tags {
    key   = "Name"
    value = "internet_service01"
  }
}

resource "outscale_internet_service_link" "internet_service_link01" {
  net_id              = outscale_net.net01.net_id
  internet_service_id = outscale_internet_service.internet_service01.id
}

# nat gw
resource "outscale_public_ip" "public_ip01" {
  tags {
    key   = "Name"
    value = "public_ip01"
  }
}

resource "outscale_nat_service" "nat_service01" {
  subnet_id    = outscale_subnet.public_subnet01.subnet_id
  public_ip_id = outscale_public_ip.public_ip01.public_ip_id
  tags {
    key   = "Name"
    value = "nat_service01"
  }
}

resource "outscale_route_table" "route_table02" {
  net_id = outscale_net.net01.net_id
  tags {
    key   = "Name"
    value = "route_table02"
  }
}

resource "outscale_route" "route02" {
  destination_ip_range = "0.0.0.0/0"
  nat_service_id       = outscale_nat_service.nat_service01.nat_service_id
  route_table_id       = outscale_route_table.route_table02.route_table_id
}

resource "outscale_route_table_link" "route_table_link02" {
  subnet_id      = outscale_subnet.private_subnet02.subnet_id
  route_table_id = outscale_route_table.route_table02.id
}
