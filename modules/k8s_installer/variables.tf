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

variable "copy_script_to_remote" {
  type        = bool
  description = "Copy local script to remote node"
  default     = true
}

// Set this value to false to run the script on a
// worker node
variable "master_node_script" {
  type        = bool
  description = "Only run for master nodes"
  default     = true
}

// Set this value to false to run the script on a
// master node
variable "worker_node_script" {
  type        = bool
  description = "Only run for worker nodes"
  default     = true
}

variable "kubeadm_init" {
  type        = bool
  description = "Only for kubeadm init script" 
  default     = false
}

variable "join_cluster" {
  type        = bool
  description = "Only for join cluster script" 
  default     = false
}

variable "create_token" {
  type        = bool
  description = "Set true to run create token script" 
  default     = false
}
