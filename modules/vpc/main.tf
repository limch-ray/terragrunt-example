locals {
  cidr = var.cidr
  azs = var.azs
  intra_subnets = var.intra_subnets
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets
  name = var.name_prefix
  project_name = var.project_name
  environment = var.environment
  tags_common = var.tags_common
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.project_name}-${local.environment}"
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

  tags = local.tags_common
}
