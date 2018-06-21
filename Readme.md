# CI/CD for solutions based on Containers Orchestration

## Motivation

Modern applications require developing code in different platforms and tools, leveraging the need of a mechanism to integrate and validate its changes.
Continuous Integration (CI) and Continuous Delivery (CD) embody a culture, set of operating principles, and collection of practices that enable application development teams to deliver code changes more frequently and reliably. 

The goal of CI is to establish a consistent and automated way to build, package, and test applications. With consistency in the integration process in place, teams are more likely to commit code changes more frequently, which leads to better collaboration and software quality. Most teams work with multiple environments other than the production, such as development and testing environments, and CD ensures there is an automated way to push code changes to them.

What this pattern aims to do is to define a general CI/CD pipeline for scalable solutions that require containers orchestration.

## Architecture Overview

![General Architecture](/images/general-architecture.JPG)

The image above is a generic architecture overview that can be implemented using different technologies and services. In this document we are describing the steps to set up a [Jenkins](https://jenkins.io/) server connected to a Kubernetes Cluster to receive the deployments. These are the services used for implementation:

- **GitHub** as the git repository;
- **Jenkins** as the build/release automation orchestrator server;
- **Azure Container Registry** as the container repository;
- **Azure Kubernetes Service (AKS)** as container orchestrator.


## Implementation
### Prerequisites

Azure resources:
+ [Jenkins VM](https://docs.microsoft.com/en-us/azure/jenkins/)
+ Service Principal
+ [Azure Container Registry](https://docs.microsoft.com/en-us/azure/container-registry/)
+ [AKS (Kubernetes Cluster)](https://docs.microsoft.com/en-us/azure/aks/)

Server Dependencies:

+ Docker
+ Kubectl
+ helm
+ JQ
+ Azure Cli

### Deploying Jenkins VM 

[Jenkins VM Azure Doc](https://docs.microsoft.com/en-us/azure/jenkins/install-jenkins-solution-template)

### Creating Azure Container Registry

[Creating Azure Container Registry](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-portal)

### Deploying Kubernetes Cluster

[Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-deploy-cluster)

### Installing Jenkins Server Dependencies 

Install Docker

	curl -sSL https://get.docker.com | sudo -E sh

Add jenkins user to Docker Group

	sudo usermod -aG docker jenkins

Restart jenkins service

	sudo service jenkins restart

(Optional) - test that the jenkins user has sufficient permissions for docker

	sudo su jenkins
	docker info
	#if previous command is successful
	exit

Install kubectl

	az login
	sudo az aks install-cli

(Optional) - test that kubectl is available in PATH

	kubectl version

Get Azure Kubernetes Service configuration for admin and jenkins user

	az login
	az aks get-credentials --resource-group={RESOURCEGROUP} --name={CLUSTERNAME}

    sudo su jenkins
	az aks get-credentials --resource-group={RESOURCEGROUP} --name={CLUSTERNAME}
	exit
	
(Optional) verify.kube/config exists in /var/lib/jenkins

	cat /var/lib/jenkins/.kube/config

Install Helm

	wget https://storage.googleapis.com/kubernetes-helm/helm-v2.9.1-linux-amd64.tar.gz
	tar -xzvf helm-v2.9.1-linux-amd64.tar.gz
	sudo mv linux-amd64/helm /usr/local/bin/helm
	sudo helm init

### Jenkins 'Execute shell' Commands 

	#Azure Container Registry config
	REPO_NAME="azure-voting-app-redis"
	ACR_LOGINSERVER="myrepo.azurecr.io"
	IMAGE_NAME="${ACR_LOGINSERVER}/$REPO_NAME:jenkins${BUILD_NUMBER}"
 
	#Docker build and push to Azure Container Registry
	docker build -t $IMAGE_NAME .
	docker login ${ACR_LOGINSERVER} -u ${ACR_ID} -p ${ACR_PASSWORD}
	docker push $IMAGE_NAME
	 
	#HELM config
	NAME="azure-voting-app-redis"
	HELM_CHART="./helm/azure-voting-app-redis"
	 
	#Kubenetes config (for safety, in order to make sure it runs in the selected K8s context)
	KUBE_CONTEXT="jenkinsupskillingcluster"
	kubectl config --kubeconfig=/var/lib/jenkins/.kube/config view
	kubectl config set-context $KUBE_CONTEXT
	 
	#Helm Deployment
	helm --kube-context $KUBE_CONTEXT upgrade --install --force $NAME $HELM_CHART --set image.repository=${ACR_LOGINSERVER}/$REPO_NAME --set image.tag=jenkins${BUILD_NUMBER} 
	 
	#If credentials are required for pulling docker image, supply the credentials to AKS by running the following:
	#kubectl create secret -n $NAME docker-registry regcred --docker-server=${ACR_LOGINSERVER} --docker-username=${ACR_ID} --docker-password=${ACR_PASSWORD} --docker-email=myemail@contoso.com