variable "prefix_name" {
  type    = string
  default = "test"
}

variable "image_name" {
  type    = string
  #default = "ami-ff13275d"
  default = "ami-47899c77"
}

variable "keypair_name" {
  type = string
}

variable "ssh_authorized_keys" {
  type    = list(string)
  default = []
}
variable "docker_version" {
  default = "docker-ce=5:19.03.11~3-0~debian-stretch"
}
variable "docker_compose_version" {
  default = ""
}

variable "dockerhub_login" {
  default = ""
}
variable "dockerhub_token" {
  default = ""
}
variable "github_token" {
  default = ""
}
variable "docker_registry_username" {
  default = ""
}
variable "docker_registry_token" {
  default = ""
}

