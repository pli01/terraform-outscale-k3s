terraform {
  required_version = ">= 0.14"
  required_providers {
    outscale = {
      version = "0.4.1"
      source = "outscale-dev/outscale"
    }
    random = {}
    cloud-init = {
     version = "2.2.0"
     source = "hashicorp/cloudinit"
    }
  }
}
