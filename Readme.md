# Jenkins Helm Pipeline

## Introduction

In this HowTo we are describing the steps to set up a [Jenkins](https://jenkins.io/) server connected to a Kubernetes Cluster to receive the deployments.

## 1. Architecture Overview

![General Architecture](/images/general-architecture.JPG)

The image above is a generic architecture overview that can be implemented using different technologies and services. These are the services used for implementation:

- **GitHub** as the git repository;
- **Jenkins** as the build/release automation orchestrator server;
- **Azure Container Registry** as the container repository;
- **Azure Kubernetes Service (AKS)** as container orchestrator.

## 2. Implementation
### 2.1. Requisites

Azure resources:
+ Jenkins VM
+ Service Principal
+ Azure Container Registry
+ AKS (Kubernetes Cluster)

Server Dependencies:

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
