output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "private_subnets_arns" {
  value = module.vpc.private_subnet_arns
}
