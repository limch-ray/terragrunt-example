locals {
  cidr = var.cidr
  azs = var.azs
  intra_subnets = var.intra_subnets
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets
}

terraform {
  required_version = ">= 0.14.0"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project_name}-${var.environment}"
  cidr = local.cidr
  azs = local.azs
  intra_subnets = local.intra_subnets
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  private_subnet_tags = {
    Type = "private"
  }

  public_subnet_tags = {
    Type = "public"
  }

  intra_subnet_tags = {
    Type = "intra"
  }

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  tags = var.tags_common
}
