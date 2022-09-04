#!/bin/bash
#############################################################################
# Turn swap off
swapoff -a

#############################################################################
# In order for a Linux node's iptables to correctly view bridged traffic,
# verify that net.bridge.bridge-nf-call-iptables is set to 1 in your sysctl
# config.
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system


#############################################################################
# Install containerd
sudo DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  -o "Dpkg::Options::=--force-confold" \
  -o "Dpkg::Options::=--force-confdef" \
  -y --allow-downgrades --allow-remove-essential
sudo apt-get -y install containerd

sudo mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml
sed -i 's/ SystemdCgroup = false/ SystemdCgroup = true/' /etc/containerd/config.toml

sudo systemctl restart containerd
