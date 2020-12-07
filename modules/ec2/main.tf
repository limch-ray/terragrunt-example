terraform {
  required_version = ">= 0.14.0"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_vpc" "vpcs" {
  filter {
    name = "cidr-block-association.cidr-block"
    values = ["10.1.0.0/22"]
  }
}

data "aws_subnet_ids" "subids" {
  vpc_id = data.aws_vpc.vpcs.id

  tags = {
    Type = "private"
  }
}

resource "aws_instance" "web" {
  for_each      = data.aws_subnet_ids.subids.ids
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = each.value
}
