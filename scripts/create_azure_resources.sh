#!/bin/bash
set -e
echo 'Change the variables values at terraform.tfvars and secrets.tfvars files' >&2
echo 'If you did not check those file cancel the script execution! ' >&2

#Check if the terraform is present.
if ! [ -x "$(command -v terraform)" ]; then

    #check if unzip is present
    if ! [ -x "$(command -v unzip)" ]; then
        sudo apt-get update
        sudo apt-get install unzip
    fi

    echo 'Terraform is not installed in your system! Starting installation...' >&2
    wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
    unzip terraform_0.11.1_linux_amd64.zip
    sudo mv terraform /usr/local/bin/
    echo 'Terraform installed continuing with the installation' >&2
fi

cd ../src/terraform

#terraform will create the Jenkins VM, AKS Cluster and set the jenkins vm to use the AKS Cluster.
#Initialize terraform project
terraform init 

#Check the changes to be made on azure
#terraform plan -var-file=secrets.tfvars

#Apply the changes
terraform apply -var-file=secrets.tfvars

echo 'Setting Up Jenkins Server '
ssh `eval terraform output admin_username`@`eval terraform output jenkins_pip` 'bash -s' < ../../scripts/setup_jenkins.sh

echo 'Copying .Kube_config to remote machine'
terraform output kube_config > .kube_config
ssh `eval terraform output admin_username`@`eval terraform output jenkins_pip` 'mkdir -p /home/'`eval terraform output admin_username`'/.kube'
scp .kube_config `eval terraform output admin_username`@`eval terraform output jenkins_pip`:/home/`eval terraform output admin_username`/.kube/config
ssh `eval terraform output admin_username`@`eval terraform output jenkins_pip` 'sudo cp -r /home/'`eval terraform output admin_username`'/.kube /var/lib/jenkins/'
ssh `eval terraform output admin_username`@`eval terraform output jenkins_pip` 'sudo chown -R jenkins /var/lib/jenkins/.kube'
rm .kube_config

