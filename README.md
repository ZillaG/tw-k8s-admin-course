k8s-admin-course
================
These are Terraform script I put together as I follow the Techworld with Nana k8s admin course. It sets up one master node and two worker nodes. You will need some Terraform knowledge to use them. These are not meant for production. **Use them at your own risk!!!**

## Prerequisites
  - Terraform <=1.2.8
  - awscli v2.7.27
  - Generated AWS SSH key/pair

## Modify the provider.tf file
I use AWS as my provider and use an S3 bucket for my Terraform states. You'll need to modify the provider.tf file to meet your needs.

## Input parameters
You will need to provide these input paramters

  - ssh_key_name = Your generated AWS SSH key name
  - ssh_key_file = the absolute path location of your SSH private key
  - home_ip      = your home IP address to configure SSH

## Usage
### To create infrastructure

    $ terraform init (first use, and after adding a module)
    $ terraform validate (after any changes)
    $ terraform plan -var "ssh_key_name=name_of_ssh_key" -var "ssh_key_file=absolute_path_of_key_file" -var "home_ip=your_home_ip_address" -out out.o
    $ terraform apply out.o

### To destroy infrastructure

    $ terraform plan -destroy -var "ssh_key_name=name_of_ssh_key" -var "ssh_key_file=absolute_path_of_key_file" -var "home_ip=your_home_ip_address" -out out.o
    $ terraform apply out.o
