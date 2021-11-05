terraform {
  required_version = ">= 0.13"
  required_providers {
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.2.0"
    }
    outscale = {
      source = "outscale-dev/outscale"
    }
  }
}
