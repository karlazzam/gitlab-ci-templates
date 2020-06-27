locals {
  my_ip_cidr = "${var.my_ip_address}/32"
}

variable "my_ip_address" {
  type        = string
  description = "my local ip address needed to apply security group inbound rules for access to the instance locally"
}
variable "new_ssh_port" {
  type    = number
  default = 22
}

variable "application_port" {
  type    = number
  default = 8080
}

variable "ami_id" {
  type    = string
  default = "ami-01e36b7901e884a10" # centos 7 ami
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "keypair_name" {
  type    = string
  default = "my-keypair"
}

variable "iam_role_name" {
  type    = string
  default = "my-role"
}

variable "volume_type" {
  type    = string
  default = "gp2" # io1
}

variable "volume_size" {
  type    = number
  default = 8 # gigabytes
}

variable "route_53_domain_name" {
  type    = string
  default = "www.mydomain.com"
}

variable "route_53_primary_zone_id" {
  type    = string
  default = "my-primary-zone"
}

variable "env_name" {
  type    = string
  default = "prod"
}

variable "application_name" {
  type    = string
  default = "my-application"
}
