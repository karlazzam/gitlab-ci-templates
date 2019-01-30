variable "instance_type" {
  description = "AWS instance type"
  type        = "string"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AWS instance ami id."
  type        = "string"
}
