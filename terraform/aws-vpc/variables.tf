variable "vpc_name" {
  type    = string
  default = "my-vpc"
}

variable "env_name" {
  type    = string
  default = "prod"
}

variable "enable_nat_gateway" {
  type    = bool
  default = false
}

variable "enable_vpn_gateway" {
  type    = bool
  default = false
}

variable "availability_zone_names" {
  type    = list(string)
  default = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

