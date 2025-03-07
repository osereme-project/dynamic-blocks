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
  id = "vpc-id"
}


locals {
  aws_instance =[{
    ami           = "ami-id"
    instance_type = "instance-type"
  }]

  ingress = [{
    port        = "port number"
    description = "Port description"
    protocol    = "protocol-type"
    },
    {
      port        = "port number"
      description = "Port description"
      protocol    = "protocol-type"
  }]
}


resource "aws_security_group" "resource-name" {
  name        = "resource-name"
  description = ""
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
      description      = ingress.value.description
      from_port        = ingress.value.from.port
      to_port          = ingress.value.to.port
      protocol         = ingress.value.protocol
      cidr_blocks      = vpc.virtual-network.cidr_block
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}
