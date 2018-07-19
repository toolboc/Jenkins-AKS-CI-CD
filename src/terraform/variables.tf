# Azure Resources Location
variable "location" {
    type        = "string"
    description = "Azure dc location you will deploy the infrastructure"
    default     = "eastus"
}


# resource group
variable "cluster_resource_group" {
    type        = "string"
    description = "Azure resource group name"
    default     = "k8shelm"
}


# Network
variable "network_name" {
  type          = "string"
  description   = "Virtual Network Name"
  default       = "upskilling"
}
variable "vnet_cidr" { 
  type          = "string"
  description   = "address space for the virtual network"
  default       = "192.168.0.0/16" 
}


variable "subnet_name" {
  type          = "string"
  description   = "Virtual Network Subnet Name"
  default       = "default"
}

variable "subnet_cidr" { 
  type          = "string" 
  default       = "192.168.1.0/24" 
  description   = "virtual network subnet address space"
}

# Storage Account
variable  "storage_account_name" {
  type          = "string" 
  default       = "k8shelm" 
  description   = "storage account name"
}

# Jenkins VM

variable "jenkins_vm_name" {
  type          = "string"
  description   = "Jenkins VM name"
  default       = "jenkins_vm"
}

variable "jenkins_vm_size" {
  type          = "string"
  description   = "Jenkins VM Type"
  default       = "Basic_A1"
}


# Linux Variables
variable "admin_username" {
  type = "string"
  description = "linux admin username"
  default = "visouza"
}
variable "ssh_key" {
  type = "string"
  description = "ssh key "
}

# Aks cluster
variable "aks_name" {
  type = "string"
  description = "Name of the AKS service created" 
}

variable "aks_dns_prefix" {
  type = "string"
  description = "dns prefix"
}



variable "aks_agent_vm_type" {
  type = "string"
  description = "type of vm that will be used" 
}

variable "aks_agent_os_type" {
  type = "string"
  description = "operation system that will be used Linux|Windows"
}


# Subscription
variable "subscription_id" {
    type        = "string"
    description = "Azure subscription ID"
}

variable "client_id" {
    type        = "string"
    description = "Azure Service Principal id (client id)"
}

variable "client_secret" {
    type        = "string"
    description = "Azure client Service Principal secret (client secret)"
}

variable "tenant_id" {
    type        = "string"
    description = "Azure tenant or directory id"
}

# Resources Tags
variable "environment_tag" {
  type = "string"
  description = "type of environment Production, development, QA"
}


