#!/bin/bash
set -e

export k8sClusterName="jenkins-k8s-azure"
export RG="jenkins-k8s-azure"
export LOCATION=eastus

#Install az aks-cli & kubectl
sudo az aks install-cli

#Create azure resources
az group create -n $RG -l $LOCATION
az aks create -n $k8sClusterName -g $RG --generate-ssh-keys
az aks get-credentials -n $k8sClusterName -g $RG

#Copy kube config and set permissions for jenkins user
sudo cp -R ~/.kube /var/lib/jenkins
sudo chown -R jenkins:jenkins /var/lib/jenkins/.kube/

#Install Docker
curl -sSL https://get.docker.com | sudo -E sh
sudo usermod -aG docker jenkins

#Restart jenkins
sudo service jenkins restart

#Install Helm
wget https://storage.googleapis.com/kubernetes-helm/helm-v2.9.1-linux-amd64.tar.gz
tar -xzvf helm-v2.9.1-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
sudo helm init