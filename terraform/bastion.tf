variable "image_name" {
  type    = string
  default = "ami-ff13275d"
}

variable "vm_type" {
  type    = string
  default = "t2.nano"
}

variable "keypair_name" {
  type    = string
}

variable "maxcount" {
  type    = number
  default = 1
}
# bastion userdata
data "cloudinit_config" "bastion_config" {
  gzip          = false
  base64_encode = true

  # order matter
  # cloud-init.cfg
  part {
    filename     = "cloud-init.cfg"
    content_type = "text/cloud-config"
    content      = file("${path.module}/config-scripts/cloud-init.tpl")
  }
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/config-scripts/configure_ssh.sh")
  }
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/config-scripts/install_docker.sh")
  }
}

resource "outscale_vm" "bastion" {
  count = var.maxcount
  image_id           = var.image_name
  vm_type            = var.vm_type
  keypair_name       = var.keypair_name
  security_group_ids = [outscale_security_group.security_group01.security_group_id]
  subnet_id          = outscale_subnet.subnet01.subnet_id
  user_data = data.cloudinit_config.bastion_config.rendered
  tags {
    key   = "Name"
    value = format("%s-%s", "bastion", count.index)
  }
}

resource "outscale_public_ip" "public_ip_bastion" {
  count = var.maxcount
  tags {
    key   = "Name"
    value = format("%s-%s", "public_ip_bastion", count.index)
  }
}

resource "outscale_public_ip_link" "public_ip_link" {
  count = var.maxcount
  vm_id     = outscale_vm.bastion[count.index].vm_id
  public_ip = outscale_public_ip.public_ip_bastion[count.index].public_ip
}
