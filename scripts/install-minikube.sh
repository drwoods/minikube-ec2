#!/usr/bin/bash
# Repo: https://github.com/drwoods/minikube-ec2/
# License: ASL 2.0 - http://www.apache.org/licenses/LICENSE-2.0
# Description: Script to install Minikube on a single Amazon Linux v2 AMI
# Idea based on script from: https://github.com/robertluwang/docker-hands-on-guide/

sudo true
sudo yum update -y
sudo yum -y install ebtables socat docker
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -a -G docker ec2-user
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/bin/
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/bin/
echo "export MINIKUBE_WANTUPDATENOTIFICATION=false" >> /home/ec2-user/.bash_profile
echo "export MINIKUBE_WANTREPORTERRORPROMPT=false" >> /home/ec2-user/.bash_profile
echo "export MINIKUBE_HOME=/home/ec2-user" >> /home/ec2-user/.bash_profile
echo "export CHANGE_MINIKUBE_NONE_USER=true" >> /home/ec2-user/.bash_profile
echo "export KUBECONFIG=/home/ec2-user/.kube/config" >> /home/ec2-user/.bash_profile
echo "source <(kubectl completion bash)" >> /home/ec2-user/.bash_profile
mkdir /home/ec2-user/.kube && touch /home/ec2-user/.kube/config
source /home/ec2-user/.bash_profile
sudo -E minikube start --vm-driver=none --apiserver-ips 127.0.0.1 --apiserver-name localhost
# Update file ownership
sudo chown -R ec2-user:ec2-user /home/ec2-user/.minikube
# Enable some add-ons
sudo -E minikube addons enable dashboard
sudo -E minikube addons enable ingress
sudo -E minikube addons enable metrics-server
# Setup hosts file
echo "127.0.0.1 local.host minikube" | sudo tee -a /etc/hosts
echo "$(sudo -E minikube ip) $(hostname)" | sudo tee -a /etc/hosts
# Download Helm and install Tiller
curl -Lo get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get && chmod 700 get_helm.sh && ./get_helm.sh
helm init --history-max 200
helm repo update
