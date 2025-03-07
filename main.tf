terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.48.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

data "aws_vpc" "virtual-network" {
  id = "vpc-0e9f0f30a0a64e0ca"
}


locals {
  aws_instance =[{
    ami           = "ami-04b70fa74e45c3917"
    instance_type = "t2.micro"
  }]

  ingress = [{
    port        = 443
    description = "Port 443"
    protocol    = "tcp"
    },
    {
      port        = 80
      description = "Port 80"
      protocol    = "tcp"
  }]
}


resource "aws_security_group" "project_server_1_sg" {
  name        = "project_server_1_sg"
  description = "project_server_1 security group"
  vpc_id      = data.aws_vpc.virtual-network.id

  dynamic "ingress" {
    for_each = local.ingress
    content {
      description      = ingress.value.description
      from_port        = ingress.value.port
      to_port          = ingress.value.port
      protocol         = ingress.value.protocol
      cidr_blocks      = [data.aws_vpc.virtual-network.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  }

  egress = [
    {
      description      = "outgoing traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}