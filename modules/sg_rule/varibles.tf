variable "type" {
  type = string
  default = "ingress"
}

variable "from_port" {
  type = string
}

variable "to_port" {
  type = string
}

variable "protocol" {
  type = string
}

variable "cidr_blocks" {
  type = list
}

variable "sg_id" {
  type = string
}

variable "description" {
  type = string
}
