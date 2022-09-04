resource "aws_vpc" "vpc" {
  cidr_block = var.cidr

  tags = {
    Name = var.name
  }
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_arn" {
  value = aws_vpc.vpc.arn
}

output "vpc_sg_id" {
  value = aws_vpc.vpc.default_security_group_id
}

output "vpc_default_rtb_id" {
  value = aws_vpc.vpc.default_route_table_id
}
