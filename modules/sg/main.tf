resource "aws_security_group" "security_group" {
  name                   = var.name
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  tags = {
    Name = var.name
  }
}

output "sg_id" {
  value = aws_security_group.security_group.id
}
