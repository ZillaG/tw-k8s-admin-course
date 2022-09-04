#!/bin/bash
#############################################################################
# Turn swap off
swapoff -a

#############################################################################
# Update the apt package index and install packages needed to use the
# Kubernetes apt repository
sudo DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  -o "Dpkg::Options::=--force-confold" \
  -o "Dpkg::Options::=--force-confdef" \
  -y --allow-downgrades --allow-remove-essential 
sudo apt-get -y install containerd
sudo apt-get install -y apt-transport-https ca-certificates curl

# Download the Google Cloud public signing key:
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

#Add the Kubernetes apt repository:
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update apt package index, install kubelet, kubeadm and kubectl, and pin their version:
sudo DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  -o "Dpkg::Options::=--force-confold" \
  -o "Dpkg::Options::=--force-confdef" \
  -y --allow-downgrades --allow-remove-essential 
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
