locals {
  cidr = var.cidr
  azs = var.azs
  intra_subnets = var.intra_subnets
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets
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
    type = "private"
  }

  public_subnet_tags = {
    type = "public"
  }

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  tags = var.tags_common
}
