variable "enable_nat_gateway" {
}

variable "cidr" {
}

variable "azs" {
}
                 
variable "intra_subnets" {
}

variable "private_subnets" {
}

variable "public_subnets" {
}

variable "project_name" {
}

variable "environment" {
}

variable "tags_common" {
  type = map(any)
  default = {}
}
