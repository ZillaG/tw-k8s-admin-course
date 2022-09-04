// These values are passed-in by the calling module
variable "ssh_key_file" {
  type = string
}

variable "ec2_pub_ip" {
  type = string
}

variable "shell_script" {
  type = string
}
