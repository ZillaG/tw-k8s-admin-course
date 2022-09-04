resource "aws_instance" "ec2" {
  ami                         = var.ami_id
  associate_public_ip_address = true
  availability_zone           = var.availability_zone
  disable_api_termination     = var.termination_protection
  instance_type               = var.instance_type
  key_name                    = var.ssh_key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids

  ###############################################################
  # Testing ssh is a cheap way to pend that the EC2 is up

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_key_file)
    host        = aws_instance.ec2.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "ls -al"
    ]
  }

  ###############################################################

  tags = {
    Name        = var.ec2_tag_name
  }
}

output "ec2_id" {
  value = aws_instance.ec2.id
  description = "Instance id of EC2"
}

output "ec2_priv_ip" {
  value = aws_instance.ec2.private_ip
  description = "Private IP address of EC2"
}

output "ec2_pub_ip" {
  value = aws_instance.ec2.public_ip
  description = "Private IP address of EC2"
}
