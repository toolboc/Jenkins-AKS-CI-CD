#location
location                                = "East US"

# Resource Groups
cluster_resource_group                  = "k8shelm"

# Jenkins VM 
jenkins_vm_name                         = "jenkinsupskillingvm"

#AKS - Kubernete Cluster Service
aks_name                                = "jenkinsupskillingcluster"
aks_dns_prefix                          = "jenkinsupskillingcluster"
aks_admin_username                      = "visouza"
aks_agent_vm_type                       = "Standard_DS3"
aks_agent_os_type                       = "Linux"

#tag
environment_tag                         = "Production"


# Define the following variables 
#subscription_id                     = "<your subscription id>"
#client_id                           = "<Service principal client id>"
#client_secret                       = "<Service principal client secret>"
#tenant_id                           = "<Tenant Id>"
#aks_ssh_key                         = "ssh-rsa <your public key here>"