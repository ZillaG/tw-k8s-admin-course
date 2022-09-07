// Create an VPCs, IGW, Security Groupss, and EC2s
module "k8s_vpc" {
  source                 = "../modules/vpc"
  name                   = var.vpc_name
  cidr                   = var.vpc_cidr
}

// The IGW needs the above VPC ID
module "k8s_igw" {
  source                 = "../modules/igw"
  name                   = "k8s-igw"
  vpc_id                 = module.k8s_vpc.vpc_id
}

// Update the above VPC's default route table to include
// 0.0.0.0/0 route to the above IGW to enable SSH access
module "k8s_rtb_route" {
  source                 = "../modules/rtb_route"
  rtb_id                 = module.k8s_vpc.vpc_default_rtb_id
  cidr                   = "0.0.0.0/0"
  igw_id                 = module.k8s_igw.igw_id
}

// Master SG
module "k8s_sg_master" {
  source                 = "../modules/sg"
  name                   = "k8s-sg-master"
  vpc_id                 = module.k8s_vpc.vpc_id
}
// Worker SG
module "k8s_sg_worker" {
  source                 = "../modules/sg"
  name                   = "k8s-sg-worker"
  vpc_id                 = module.k8s_vpc.vpc_id
}

// Update the above security groups' rules
module "k8s_sg_master_rule" {
  for_each               = var.sg_rules_master
  source                 = "../modules/sg_rule"
  type                   = "ingress"
  from_port              = each.value.from_port
  to_port                = each.value.to_port
  protocol               = each.value.protocol
  cidr_blocks            = each.value.cidr_blocks
  description            = each.value.description
  sg_id                  = module.k8s_sg_master.sg_id
}
module "k8s_sg_worker_rule" {
  for_each               = var.sg_rules_worker
  source                 = "../modules/sg_rule"
  type                   = "ingress"
  from_port              = each.value.from_port
  to_port                = each.value.to_port
  protocol               = each.value.protocol
  cidr_blocks            = each.value.cidr_blocks
  description            = each.value.description
  sg_id                  = module.k8s_sg_worker.sg_id
}

// Separate the SSH rule so the home_ip variable can be used; variables
// cannot be used in the variables.tf file (LOL!).
module "k8s_sg_ssh_rule" {
  for_each               = tomap({a=module.k8s_sg_master.sg_id, b=module.k8s_sg_worker.sg_id})
  source                 = "../modules/sg_rule"
  type                   = "ingress"
  from_port              = "22"
  to_port                = "22"
  protocol               = "tcp"
  cidr_blocks            = ["${var.home_ip}/32"]
  description            = "Allow SSH from home IP"
  sg_id                  = each.value
}

module "k8s_subnet_us_east_1a" {
  source                 = "../modules/subnet"
  name                   = var.vpc_name
  availability_zone      = var.az_us_east_1a
  cidr_block             = var.cidr_us_east_1a
  vpc_id                 = module.k8s_vpc.vpc_id
}

module "k8s_ec2_master_0" {
  source                 = "../modules/ec2"
  ec2_tag_name           = var.ec2_master_0
  ami_id                 = var.ec2_ami_ubuntu
  availability_zone      = var.az_us_east_1a
  instance_type          = "t2.medium"
  ssh_key_name           = var.ssh_key_name
  ssh_key_file           = var.ssh_key_file
  subnet_id              = module.k8s_subnet_us_east_1a.subnet_id
  vpc_security_group_ids = [module.k8s_vpc.vpc_sg_id, module.k8s_sg_master.sg_id]
}

module "k8s_ec2_worker_0" {
  source                 = "../modules/ec2"
  ec2_tag_name           = var.ec2_worker_0
  ami_id                 = var.ec2_ami_ubuntu
  availability_zone      = var.az_us_east_1a
  instance_type          = "t2.large"
  ssh_key_name           = var.ssh_key_name
  ssh_key_file           = var.ssh_key_file
  subnet_id              = module.k8s_subnet_us_east_1a.subnet_id
  vpc_security_group_ids = [module.k8s_vpc.vpc_sg_id, module.k8s_sg_worker.sg_id]
}

module "k8s_ec2_worker_1" {
  source                 = "../modules/ec2"
  ec2_tag_name           = var.ec2_worker_1
  ami_id                 = var.ec2_ami_ubuntu
  availability_zone      = var.az_us_east_1a
  instance_type          = "t2.large"
  ssh_key_name           = var.ssh_key_name
  ssh_key_file           = var.ssh_key_file
  subnet_id              = module.k8s_subnet_us_east_1a.subnet_id
  vpc_security_group_ids = [module.k8s_vpc.vpc_sg_id, module.k8s_sg_worker.sg_id]
}

// Install containerd in all the nodes
module "k8s_containerd" {
  depends_on             = [module.k8s_ec2_master_0, module.k8s_ec2_worker_0, module.k8s_ec2_worker_1]
  for_each               = tomap({a=module.k8s_ec2_master_0.ec2_pub_ip, b=module.k8s_ec2_worker_0.ec2_pub_ip, c=module.k8s_ec2_worker_1.ec2_pub_ip})
  source                 = "../modules/k8s_installer"
  ssh_key_file           = var.ssh_key_file
  ec2_pub_ip             = each.value
  shell_script           = "install-containerd.sh"
}

// Install kubelet, kubeadm, and kubectl
module "k8s_kube_star" {
  depends_on             = [module.k8s_containerd]
  for_each               = tomap({a=module.k8s_ec2_master_0.ec2_pub_ip, b=module.k8s_ec2_worker_0.ec2_pub_ip, c=module.k8s_ec2_worker_1.ec2_pub_ip})
  source                 = "../modules/k8s_installer"
  ssh_key_file           = var.ssh_key_file
  ec2_pub_ip             = each.value
  shell_script           = "install-kube-star.sh"
}

// Initialize kubeadm on the master node ONLY.
module "k8s_init_kubeadm" {
  depends_on             = [module.k8s_kube_star]
  source                 = "../modules/k8s_installer"
  ssh_key_file           = var.ssh_key_file
  ec2_pub_ip             = module.k8s_ec2_master_0.ec2_pub_ip
  shell_script           = "init-kubeadm.sh"
  kubeadm_init           = true
  worker_node_script     = false
}

// Create command to join cluster on the master node
module "k8s_create_token" {
  depends_on             = [module.k8s_init_kubeadm]
  source                 = "../modules/k8s_installer"
  ssh_key_file           = var.ssh_key_file
  ec2_pub_ip             = module.k8s_ec2_master_0.ec2_pub_ip
  shell_script           = "join-cluster.sh"
  worker_node_script     = false
  create_token           = true
}

// Run command to join cluster on the worker nodes
module "k8s_join_cluster" {
  depends_on             = [module.k8s_create_token]
  for_each               = tomap({a=module.k8s_ec2_worker_0.ec2_pub_ip, b=module.k8s_ec2_worker_1.ec2_pub_ip})
  source                 = "../modules/k8s_installer"
  ssh_key_file           = var.ssh_key_file
  ec2_pub_ip             = each.value
  shell_script           = "join-cluster.sh"
  master_node_script     = false
  join_cluster           = true
  copy_script_to_remote  = false # script is on remote
}

// Install Weavenet CNI on master. This is when the nodes will
// finally show as Ready since networking will be established
// between them.
module "k8s_install_weavenet" {
  depends_on             = [module.k8s_kube_star]
  source                 = "../modules/k8s_installer"
  ssh_key_file           = var.ssh_key_file
  ec2_pub_ip             = module.k8s_ec2_master_0.ec2_pub_ip
  shell_script           = "install-weavenet.sh"
}

// VPC
output "k8s_vpc_id" {
  value = module.k8s_vpc.vpc_id
}
output "k8s_vpc_sg_id" {
  value = module.k8s_vpc.vpc_sg_id
}
output "k8s_def_rtb_id" {
  value = module.k8s_vpc.vpc_default_rtb_id
}
// IGW
output "k8s_igw_id" {
  value = module.k8s_igw.igw_id
}
// Subnet
output "k8s_subnet_us_east_1a_id" {
  value = module.k8s_subnet_us_east_1a.subnet_id
}
// EC2
output "k8s_ec2_master_0_id" {
  value = module.k8s_ec2_master_0.ec2_id
}
output "k8s_ec2_master_0_pub_ip" {
  value = module.k8s_ec2_master_0.ec2_pub_ip
}
output "k8s_ec2_master_0_priv_ip" {
  value = module.k8s_ec2_master_0.ec2_priv_ip
}
output "k8s_ec2_worker_0_id" {
  value = module.k8s_ec2_worker_0.ec2_id
}
output "k8s_ec2_worker_0_pub_ip" {
  value = module.k8s_ec2_worker_0.ec2_pub_ip
}
output "k8s_ec2_worker_0_priv_ip" {
  value = module.k8s_ec2_worker_0.ec2_priv_ip
}
output "k8s_ec2_worker_1_id" {
  value = module.k8s_ec2_worker_1.ec2_id
}
output "k8s_ec2_worker_1_pub_ip" {
  value = module.k8s_ec2_worker_1.ec2_pub_ip
}
