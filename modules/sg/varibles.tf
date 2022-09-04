variable "name" {
  type = string
}

variable "ingress" {
  type = map
  default = {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
  }
}

variable "vpc_id" {
  type = string
}
