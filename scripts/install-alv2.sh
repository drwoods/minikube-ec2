#!/usr/bin/bash
# Repo: https://github.com/drwoods/minikube-ec2/
# License: ASL 2.0 - http://www.apache.org/licenses/LICENSE-2.0
# Description: Script to install OS packages and Minikube on a single Amazon Linux v2 AMI
# Idea based on script from: https://github.com/robertluwang/docker-hands-on-guide/
# Note: This script should run with default "root" privileges in UserData

# Update OS and install needed packages
yum update -y
yum -y install ebtables socat docker

# Set Docker to auto-start
systemctl start docker.service
systemctl enable docker.service

# Allow ec2-user to use docker
usermod -a -G docker ec2-user

# Download minikube and kubectl binaries
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/bin/
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/bin/

# Update hosts file
echo "127.0.0.1 local.host minikube" >> /etc/hosts
