enable_nat_gateway = true
cidr = "10.1.0.0/16"
azs = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
intra_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
private_subnets = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]
public_subnets = ["10.1.201.0/24", "10.1.202.0/24", "10.1.203.0/24"]
