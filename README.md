# minikube-ec2
Use CloudFormation to create a Minikube instance in AWS on a Amazon Linux v2 AMI

Based on https://github.com/robertluwang/docker-hands-on-guide/blob/master/minikube-none.sh

## Deploy to AWS
The CloudFormation templates in `/deploy` can be used to create a Minikube node in AWS that uses the `/scripts` files to setup Minikube on an Amazon Linux v2 AMI.  The templates have been tested on an AWS account which has a default VPC created with Public and Private subnets, an Inet GW with open egress, along with using an IAM User with the proper permissions to create the deployment.

### Example Steps using the AWS Console
1. Use the AWS Console to login to an account where your IAM User has the Roles to allow you to create CloudFormation stacks and EC2 instances
2. Access the CloudFormation console
3. Select "Create Stack"
4. Choose "Upload a template" and choose the appropriate file from your local clone of the GitHub repo, like:
   > /deploy/cloudformation.yaml
5. On the Next screen, supply a Stack name and existing SSH Key to access the created instance, like:
   > Stack name = myMinikube
   > KeyName = myUserKeys
6. Optionally, update the Ingress IP address range and Root volume size
7. On the Next screen add any required Tags, IAM Role for CloudFormation and optionally set the Rollback on failure to No under the Advanced options to help debug stack creation errors
8. On the Next screen, Review the stack details and then Create the stack


## Using Your Minikube Instance
Once the CloudFormation - Create Stack request reaches the CREATE_COMPLETE status and the EC2 Instance (which can be found in the Resources tab for the Stack) Instance State is running and the Status Checks show both have passed, then you can SSH into your new Minikube node using the Pubic IP listed on the Description tab of the EC2 instance, like:
> ssh -i ~/.ssh/<myUserKeys>.pem ec2-user@<Public_IP>

### Running Minikube Commands
To run minikube commands (which should be very infrequent), you will need to execute them as root, like:
> sudo -E minikube status
> sudo -E minikube addons list

### Running kubectl Commands
The default ec2-user can run `kubectl` without using sudo, like:
> kubectl get services

### Running Helm Commands
The install script will download Helm and install Tiller into your Minikube instance.  The default ec2-user can run `helm` without using sudo, like:
> helm repo update
> helm list


## Restarting Your Minikube Instance
If you need to reboot or stop/start your EC2 Instance, then you will need to restart Minikube after the instance has restarted, like:
> ssh -i ~/.ssh/<myUserKeys>.pem ec2-user@<Public_IP>
> sudo -E minikube start
> sudo -E minikube status
