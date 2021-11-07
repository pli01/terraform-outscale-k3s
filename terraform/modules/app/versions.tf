terraform {
  required_version = ">= 0.13"
  required_providers {
    cloudinit = {
      source  = "hashicorp/cloudinit"
    }
    outscale = {
      source = "outscale-dev/outscale"
    }
  }
}
