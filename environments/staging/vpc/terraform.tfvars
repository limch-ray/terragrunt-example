enable_nat_gateway = true
single_nat_gateway = false
one_nat_gateway_per_az = true
cidr = "10.1.0.0/22"
azs = ["ap-southeast-1a", "ap-southeast-1b"]
intra_subnets = ["10.1.0.0/25", "10.1.0.128/25"]
private_subnets = ["10.1.1.0/25", "10.1.1.128/25"]
public_subnets = ["10.1.2.0/25", "10.1.2.128/25"]
