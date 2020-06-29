data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.bucket_name
    key    = var.key_name
    region = var.region
  }
}

resource "aws_security_group" "ec2-sg" {
  name        = var.sg_name
  description = "Allow ssh, http, and https access from your local ip address to the ec2 instance"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "SSH port open to everyone to allow ansible to ssh into the instance with the pem key"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH access from my ip address from the new port"
    from_port   = var.new_ssh_port
    to_port     = var.new_ssh_port
    protocol    = "tcp"
    cidr_blocks = [local.my_ip_cidr]
  }

  ingress {
    description = "HTTP access to 80 from my ip address"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.my_ip_cidr]
  }

  ingress {
    description = "HTTPS access to 443 from my ip address"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.my_ip_cidr]
  }

  ingress {
    description = "HTTPS access to the applications port from my ip address"
    from_port   = var.application_port
    to_port     = var.application_port
    protocol    = "tcp"
    cidr_blocks = [local.my_ip_cidr]
  }

  egress {
    description = "Allow all outbound access"
    from_port   = 0
    to_port     = 0
    protocol    = -1 #any
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform   = "true"
    Environment = var.env_name
    Name        = var.application_name
  }
}

resource "aws_iam_instance_profile" "ec2-attach-profile" {
  name = "ec2-attach-profile"
  role = var.iam_role_name
}

resource "aws_instance" "ec2_instance" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  key_name             = var.keypair_name
  iam_instance_profile = aws_iam_instance_profile.ec2-attach-profile.name

  subnet_id                   = data.terraform_remote_state.vpc.outputs.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.ec2-sg.id]
  associate_public_ip_address = true

  root_block_device {
    volume_type = var.volume_type
    volume_size = var.volume_size
  }

  tags = {
    Terraform   = "true"
    Environment = var.env_name
    Name        = var.application_name
  }
}

resource "aws_route53_record" "www" {
  zone_id = var.route_53_primary_zone_id
  name    = var.route_53_domain_name
  type    = "A"
  ttl     = "300"
  records = [aws_instance.ec2_instance.public_ip]
}
