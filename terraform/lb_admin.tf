resource "outscale_load_balancer" "admin_load_balancer01" {
  load_balancer_name = format("%s-%s", var.prefix_name, "portainer-load-balancer01")
  listeners {
    backend_port           = 80
    backend_protocol       = "HTTP"
    load_balancer_protocol = "HTTP"
    load_balancer_port     = 80
  }
  subnets            = [module.base.private_subnet_id]
  security_groups    = [module.base.lb_security_group_id]
  load_balancer_type = "internet-facing"
  tags {
    key   = "name"
    value = format("%s-%s", var.prefix_name, "portainer-load-balancer01")
  }
  tags {
    key   = "Env"
    value = var.prefix_name
  }
  depends_on = [
    module.base,
    module.k3s-master
  ]
}

resource "outscale_load_balancer_vms" "outscale_load_balancer_vms02" {
  load_balancer_name = outscale_load_balancer.admin_load_balancer01.load_balancer_name
  backend_vm_ids     = flatten(module.k3s-master[*].vm_id)
}

locals {
  lb_admin_dns_name = outscale_load_balancer.admin_load_balancer01.dns_name
}


output "lb_admin_dns_name" {
  value = local.lb_admin_dns_name
}
