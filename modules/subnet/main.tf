resource "aws_subnet" "subnet" {
  availability_zone = var.availability_zone
  cidr_block        = var.cidr_block
  vpc_id            = var.vpc_id

  tags = {
    Name = var.name
  }
}

output "subnet_id" {
  value = aws_subnet.subnet.id
}
output "subnet_arn" {
  value = aws_subnet.subnet.arn
}
