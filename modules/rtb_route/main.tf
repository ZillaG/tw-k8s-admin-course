resource "aws_route" "r" {
  route_table_id         = var.rtb_id
  destination_cidr_block = var.cidr
  gateway_id             = var.igw_id
}
