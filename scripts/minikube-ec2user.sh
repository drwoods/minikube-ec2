#!/usr/bin/bash
# Repo: https://github.com/drwoods/minikube-ec2/
# License: ASL 2.0 - http://www.apache.org/licenses/LICENSE-2.0
# Description: Script to configure/start Minikube on a single Amazon Linux v2 AMI
# Idea based on script from: https://github.com/robertluwang/docker-hands-on-guide/
# Note: This script should run as the "ec2-user" in UserData

# Setup shell env
echo "export MINIKUBE_WANTUPDATENOTIFICATION=false" >> ~/.bash_profile
echo "export MINIKUBE_WANTREPORTERRORPROMPT=false" >> ~/.bash_profile
echo "export MINIKUBE_HOME=/home/ec2-user" >> ~/.bash_profile
echo "export CHANGE_MINIKUBE_NONE_USER=true" >> ~/.bash_profile
echo "export KUBECONFIG=/home/ec2-user/.kube/config" >> ~/.bash_profile
echo "source <(kubectl completion bash)" >> ~/.bash_profile
source ~/.bash_profile

mkdir ~/.kube && touch ~/.kube/config
mkdir ~/.minikube

#sudo -E minikube start --vm-driver=none --apiserver-ips 127.0.0.1 --apiserver-name localhost --kubernetes-version=v1.11.9
sudo -E minikube start --vm-driver=none

# Update hosts file
echo "$(sudo -E minikube ip) $(hostname)" | sudo tee -a /etc/hosts
echo "$(sudo -E minikube ip) minikube" | sudo tee -a /etc/hosts

# Update file ownership
sudo chown -R ec2-user:ec2-user /home/ec2-user/.minikube
