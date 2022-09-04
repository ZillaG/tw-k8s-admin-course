#!/bin/bash
#############################################################################
# Initialize kubeadm
sudo kubeadm init

# Copy the admin.conf file to Ubuntu user
UBUNTU_KUBE_HOME=/home/ubuntu/.kube
mkdir $UBUNTU_KUBE_HOME
cp /etc/kubernetes/admin.conf $UBUNTU_KUBE_HOME/config
chown -R ubuntu:ubuntu $UBUNTU_KUBE_HOME
