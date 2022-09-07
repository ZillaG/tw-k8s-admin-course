variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The AWS region"
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
  default     = "k8s-vpc"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
  default     = "10.100.0.0/16"
}

variable "sg_rules_master" {
  type = map
  default = {
    k8s_api_server = {
      from_port   = "6443"
      to_port     = "6443"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "k8s API server"
    }
    k8s_ectd_server = {
      from_port   = "2379"
      to_port     = "2380"
      protocol    = "tcp"
      cidr_blocks = ["10.100.0.0/16"]
      description = "k8s ectd server client API"
    }
    k8s_kubelet_api = {
      from_port   = "10250"
      to_port     = "10250"
      protocol    = "tcp"
      cidr_blocks = ["10.100.0.0/16"]
      description = "k8s kubelet API"
    }
    k8s_kube_scheduler = {
      from_port   = "10251"
      to_port     = "10251"
      protocol    = "tcp"
      cidr_blocks = ["10.100.0.0/16"]
      description = "k8s kube-scheduler"
    }
    k8s_controler_manager = {
      from_port   = "10252"
      to_port     = "10252"
      protocol    = "tcp"
      cidr_blocks = ["10.100.0.0/16"]
      description = "k8s controller manager"
    }
    k8s_node_port_services = {
      from_port   = "30000"
      to_port     = "32767"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Node port services"
    }
    k8s_weavenet_services_tcp = {
      from_port   = "6781"
      to_port     = "6783"
      protocol    = "tcp"
      cidr_blocks = ["10.100.0.0/16"]
      description = "Node port services"
    }
    k8s_weavenet_services_udp = {
      from_port   = "6783"
      to_port     = "6784"
      protocol    = "udp"
      cidr_blocks = ["10.100.0.0/16"]
      description = "Node port services"
    }
  }
}

variable "sg_rules_worker" {
  type = map
  default = {
    k8s_kubelet_api = {
      from_port   = "10250"
      to_port     = "10250"
      protocol    = "tcp"
      cidr_blocks = ["10.100.0.0/16"]
      description = "k8s kubelet API"
    }
    k8s_node_port_services = {
      from_port   = "30000"
      to_port     = "32767"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Node port services"
    }
    k8s_weavenet_services_tcp = {
      from_port   = "6781"
      to_port     = "6783"
      protocol    = "tcp"
      cidr_blocks = ["10.100.0.0/16"]
      description = "Node port services"
    }
    k8s_weavenet_services_udp = {
      from_port   = "6783"
      to_port     = "6784"
      protocol    = "udp"
      cidr_blocks = ["10.100.0.0/16"]
      description = "Node port services"
    }
  }
}

variable "auto_assign_public_ip" {
  type = string
  default = "true"
  description = "Auto create public IP address"
}

variable "az_us_east_1a" {
  type = string
  default = "us-east-1a"
  description = "us-east-1a AZ"
}

variable "cidr_us_east_1a" {
  type        = string
  description = "AZ CIDR"
  default     = "10.100.10.0/24"
}


variable "ec2_ami_ubuntu" {
  type = string
  default = "ami-052efd3df9dad4825"
  description = "EC2 AMI"
}

variable "ec2_master_0" {
  type = string
  default = "k8s-master-0"
  description = "k8s master EC2"
}

variable "ec2_worker_0" {
  type = string
  default = "k8s-worker-0"
  description = "k8s worker EC2"
}

variable "ec2_worker_1" {
  type = string
  default = "k8s-worker-1"
  description = "k8s worker EC2"
}

# Note that the value must by >= to the size defined in the AMI
# that will be used.
variable "root_ebs_volume_size" {
  type = number
  default = 20
  description = "Root EBS volume size"
}

variable "root_ebs_volume_type" {
  type = string
  default = "gp2"
  description = "Root EBS volume type"
}

variable "ssh_key_name" {
  type        = string
  description = "AWS key pair to use"
}

variable "ssh_key_file" {
  type = string
  description = "Absolute path of SSH key file"
}

variable "home_ip" {
  type        = string
  description = "Home IP address to be added to SG for SSH access"
}

