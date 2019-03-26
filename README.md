# minikube-ec2
Use CloudFormation to create a Minikube instance in AWS on a Amazon Linux v2 AMI

Based on https://github.com/robertluwang/docker-hands-on-guide/blob/master/minikube-none.sh

## Deploy to AWS
The CloudFormation templates in `/deploy` can be used to create a Minikube node in AWS that uses the `/scripts` files to setup Minikube on an Amazon Linux v2 AMI.  The templates have been tested on an AWS account which has a default VPC created with Public and Private subnets, an Inet GW with open egress, along with using an IAM User with the proper permissions to create the deployment.

