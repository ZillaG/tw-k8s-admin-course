resource "null_resource" "copy_script" {
  count = var.copy_script_to_remote ? 1:0
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_key_file)
    host        = var.ec2_pub_ip
  }

  provisioner "file" {
    source      = "../modules/k8s_installer/${var.shell_script}"
    destination = "/tmp/${var.shell_script}"
  }
}

// Run script on all nodes
resource "null_resource" "generic_script" {
  count = var.master_node_script && var.worker_node_script ? 1:0
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_key_file)
    host        = var.ec2_pub_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod u+x /tmp/${var.shell_script}",
      "sudo /tmp/${var.shell_script}"
    ]
  }
}

resource "null_resource" "kubeadm_init" {
  // Run only on master nodes and kubeadm init routine
  count = var.master_node_script && var.kubeadm_init ? 1:0
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_key_file)
    host        = var.ec2_pub_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod u+x /tmp/${var.shell_script}",
      "sudo /tmp/${var.shell_script}"
    ]
  }
}

resource "null_resource" "create_join_token" {
  // Run only on master nodes
  count = var.master_node_script && var.create_token ? 1:0
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_key_file)
    host        = var.ec2_pub_ip
  }

  provisioner "remote-exec" {
    inline = [
      "kubeadm token create --print-join-command | tee /tmp/${var.shell_script}"
    ]
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${var.ssh_key_file} ubuntu@${var.ec2_pub_ip}:/tmp/${var.shell_script} /tmp/${var.shell_script}"
  }
}

resource "null_resource" "join_cluster" {
  // Run only on worker nodes
  count = var.worker_node_script && var.join_cluster ? 1:0
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_key_file)
    host        = var.ec2_pub_ip
  }

  provisioner "file" {
    source      = "/tmp/${var.shell_script}"
    destination = "/tmp/${var.shell_script}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod u+x /tmp/${var.shell_script}",
      "sudo /tmp/${var.shell_script}"
    ]
  }
}
