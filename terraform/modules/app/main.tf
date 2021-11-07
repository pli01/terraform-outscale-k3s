variable "app_name" {
  default = "app"
}
variable "image_id" {
  type    = string
  default = "ami-ff13275d"
}

variable "vm_type" {
  type    = string
  default = "tinav2.c1r1p3"
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
variable "dockerhub_login" {}
variable "dockerhub_token" {}
variable "github_token" {}
variable "docker_registry_username" {}
variable "docker_registry_token" {}

variable "app_install_script" {}
variable "app_variables" {
    type = map
    default = {}
}
# app userdata
data "cloudinit_config" "app_config" {
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
  # app.cfg sourced in app script, and contains all needed variables
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/../../config-scripts/app.cfg.tpl", {
      dockerhub_login          = var.dockerhub_login
      dockerhub_token          = var.dockerhub_token
      github_token             = var.github_token
      docker_registry_username = var.docker_registry_username
      docker_registry_token    = var.docker_registry_token
      app_install_script       = var.app_install_script
      app_variables            = var.app_variables
    })
  }
  # app post conf
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/../../config-scripts/install_app.sh")
  }
}

resource "outscale_vm" "app" {
  count              = var.maxcount
  image_id           = var.image_id
  vm_type            = var.vm_type
  keypair_name       = var.keypair_name
  security_group_ids = var.security_group_ids
  subnet_id          = var.subnet_id
  user_data          = data.cloudinit_config.app_config.rendered
  tags {
    key   = "Name"
    value = format("%s-%s", var.app_name, count.index)
  }
}

locals {
  private_ip = outscale_vm.app[*].private_ip
  vm_id = outscale_vm.app[*].vm_id
}

output "private_ip" {
  value = local.private_ip
}
output "vm_id" {
  value = local.vm_id
}
