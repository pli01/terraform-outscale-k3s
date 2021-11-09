terraform {
  backend "s3" {
    bucket = "test-k3s-terraform-state"
    key    = "network/terraform.tfstate"
    skip_region_validation = true
    skip_credentials_validation  = true
  }
}
