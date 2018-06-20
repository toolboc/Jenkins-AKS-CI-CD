# Jenkins Helm Pipeline

## Introduction

In this HowTo we are describing the steps to set up a [Jenkins](https://jenkins.io/) server connected to a Kubernetes Cluster to receive the deployments.

## Requisites

### Azure Resources

+ Jenkins VM
+ Service Principal
+ Azure Container Registry
+ AKS (Kubernetes Cluster)

### Server Dependencies

+ Docker
+ Kubectl
+ helm
+ JQ
+ Azure Cli

### Jenkins VM

[Jenkins VM Azure Doc](https://docs.microsoft.com/en-us/azure/jenkins/install-jenkins-solution-template)

### Creating ACR

[Azure Container Registry Doc](https://docs.microsoft.com/en-us/azure/container-registry/)

[Creating Azure Container Registry](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-portal)

### Kubernet Cluster

[Azure Container Service](https://docs.microsoft.com/en-us/azure/aks/)

[Creating Azure Container Registry](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough-portal)