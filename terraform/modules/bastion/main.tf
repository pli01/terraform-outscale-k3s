variable "ssh_authorized_keys" {
  type    = list(string)
  default = []
}
variable "docker_version" {
  default = ""
}
variable "docker_compose_version" {
  default = ""
}

variable "image_id" {
  type    = string
  default = "ami-ff13275d"
}

variable "vm_type" {
  type    = string
  default = "t2.nano"
}

variable "keypair_name" {
  type = string
}

variable "maxcount" {
  type    = number
  default = 1
}

variable "security_group_ids" {
  type = list(string)
}

variable "subnet_id" {
  type = string
}

variable "public_ip" {
  type = string
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
    content      = file("${path.module}/../../config-scripts/cloud-init.tpl")
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/../../config-scripts/configure_common.sh", {
      ssh_authorized_keys           = jsonencode(var.ssh_authorized_keys)
      docker_version                = var.docker_version
      docker_compose_version        = var.docker_compose_version
    })
  }
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/../../config-scripts/configure_ssh.sh")
  }
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/../../config-scripts/install_docker.sh")
  }
}

resource "outscale_vm" "bastion" {
  count              = var.maxcount
  image_id           = var.image_id
  vm_type            = var.vm_type
  keypair_name       = var.keypair_name
  security_group_ids = var.security_group_ids
  subnet_id          = var.subnet_id
  user_data          = data.cloudinit_config.bastion_config.rendered
  tags {
    key   = "Name"
    value = format("%s-%s", "bastion", count.index)
  }
}

resource "outscale_public_ip_link" "public_ip_bastion_link" {
  count     = var.maxcount
  vm_id     = outscale_vm.bastion[count.index].vm_id
  public_ip = var.public_ip
}

locals {
  private_ip = outscale_vm.bastion[*].private_ip
}

output "private_ip" {
  value = local.private_ip
}
