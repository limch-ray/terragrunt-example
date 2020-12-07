terraform {
  required_version = ">= 0.14.0"
}

data "aws_vpc" "vpcs" {
  filter {
    name = "cidr-block-association.cidr-block"
    values = ["10.1.0.0/22"]
  }
}

data "aws_subnet_ids" "intra-ids" {
  vpc_id = data.aws_vpc.vpcs.id

  tags = {
    Type = "intra"
  }
}

data "aws_subnet_ids" "private-ids" {
  vpc_id = data.aws_vpc.vpcs.id
}

data "aws_subnet" "private-ids" {
  for_each = data.aws_subnet_ids.private-ids.ids
  id       = each.value
}

data "aws_route_tables" "route-table" {
  vpc_id = data.aws_vpc.vpcs.id
}

resource "aws_security_group" "vpc-endpoint" {
  name = "${var.project_name}-${var.environment}-vpc-endpoint"
  description = "Security group for vpce"
  vpc_id = data.aws_vpc.vpcs.id
  tags = var.tags_common
}

resource "aws_security_group_rule" "to-vpc-endpoint" {
  description = "Security group for vpce"
  protocol = "tcp"
  security_group_id = aws_security_group.vpc-endpoint.id 
  cidr_blocks = [for s in data.aws_subnet.private-ids : s.cidr_block]
  from_port = 443
  to_port = 443
  type = "ingress"
}

resource "aws_vpc_endpoint" "interface" {
  vpc_id = data.aws_vpc.vpcs.id
  service_name = "com.amazonaws.ap-southeast-1.sqs"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  security_group_ids = [aws_security_group.vpc-endpoint.id]
  subnet_ids = data.aws_subnet_ids.intra-ids.ids
  tags = var.tags_common
}

resource "aws_vpc_endpoint" "gateway" {
  vpc_id = data.aws_vpc.vpcs.id
  service_name = "com.amazonaws.ap-southeast-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = data.aws_route_tables.route-table.ids
  tags = var.tags_common
}
