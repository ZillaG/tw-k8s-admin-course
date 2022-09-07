#!/bin/bash
#############################################################################
# Script to create the token on the master node that workers can use to join
# the cluster. The /tmp/join-cluster.sh file is first copied locally, then
# uploaded to the worker nodes.
kubeadm token create --print-join-command | tee /tmp/join-cluster.sh
