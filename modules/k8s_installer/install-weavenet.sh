#!/bin/bash
#############################################################################
# Install Weavenet CNI
CONF_FILE=weavenet.yaml
wget https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n') -O $CONF_FILE
sudo chown ubuntu:ubuntu $CONF_FILE
sudo kubectl apply -f $CONF_FILE --kubeconfig /etc/kubernetes/admin.conf
