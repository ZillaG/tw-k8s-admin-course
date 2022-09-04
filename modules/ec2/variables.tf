// These values are passed-in by the calling module
variable "ami_id" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "ec2_tag_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ssh_key_name" {
  type = string
}

variable "ssh_key_file" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "termination_protection" {
  type    = bool
  default = false
}

variable "vpc_security_group_ids" {
  type = list
}

// These are common to all calling modules and can be overriden using
// the -var "key=value" option
variable "iam_instance_profile" {
  type    = string
  default = "INFRASTRUCTURE-SYSTEMS"
}

variable "jenkins_home" {
  type    = string
  default = "/mnt/jenkins_master/jenkins_home"
}

variable "skip_att_ebs_destroy" {
  type    = bool
  default = false
}
