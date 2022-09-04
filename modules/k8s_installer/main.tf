resource "null_resource" "ec" {
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

  provisioner "remote-exec" {
    inline = [
      "sudo chmod u+x /tmp/${var.shell_script}",
      "sudo /tmp/${var.shell_script}"
    ]
  }
}
