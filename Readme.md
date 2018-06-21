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
### Requisites

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
