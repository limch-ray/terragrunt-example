locals {
  cidr = var.cidr
  azs = var.azs
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets
  name = var.name_prefix
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name
  cidr = local.cidr
  azs = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  private_subnet_tags = {
    type = "private"
  }

  public_subnet_tags = {
    type = "public"
  }

  enable_nat_gateway = var.enable_nat_gateway
}
