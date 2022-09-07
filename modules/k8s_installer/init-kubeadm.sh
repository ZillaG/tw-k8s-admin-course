#!/bin/bash
#############################################################################
# Initialize kubeadm
sudo kubeadm init &
BACK_PID=$!

while kill -0 $BACK_PID ; do
    echo "kubeadm init still running..."
    sleep 5
    # You can add a timeout here if you want
done

# Copy the admin.conf file to Ubuntu user
UBUNTU_KUBE_HOME=/home/ubuntu/.kube
mkdir $UBUNTU_KUBE_HOME
cp /etc/kubernetes/admin.conf $UBUNTU_KUBE_HOME/config
chown -R ubuntu:ubuntu $UBUNTU_KUBE_HOME
