#!/usr/bin/bash
# Repo: https://github.com/drwoods/minikube-ec2/
# License: ASL 2.0 - http://www.apache.org/licenses/LICENSE-2.0
# Description: Script to install add-ons and Helm in Minikube on a single Amazon Linux v2 AMI
# Idea based on script from: https://github.com/robertluwang/docker-hands-on-guide/
# Note: This script should run as the "ec2-user" in UserData

# Enable some add-ons
sudo -E minikube addons enable dashboard
sudo -E minikube addons enable ingress
sudo -E minikube addons enable metrics-server

# Download Helm and install Tiller
curl -Lo get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get && chmod +x get_helm.sh && ./get_helm.sh
helm init --history-max 200
helm version
helm repo update
