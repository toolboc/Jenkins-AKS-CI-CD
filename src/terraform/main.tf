# Creating resource group 
resource "azurerm_resource_group" "cluster" {
  name     = "${var.cluster_resource_group}"
  location = "${var.location}"
}

# Creating Azure Virtual Network
resource "azurerm_virtual_network" "jenkins_vnet" {
  name 			            = "${var.network_name}"
  address_space 	      = ["${var.vnet_cidr}"]
  location 		          = "${azurerm_resource_group.cluster.location}"
  resource_group_name   = "${azurerm_resource_group.cluster.name}"
}

resource "azurerm_subnet" "jenkins_subnet" {
  name 			            = "${var.subnet_name}"
  address_prefix 	      = "${var.subnet_cidr}"
  virtual_network_name 	= "${azurerm_virtual_network.jenkins_vnet.name}"
  resource_group_name 	= "${azurerm_resource_group.cluster.name}"
}

# Creating Azure Storage Account
resource "azurerm_storage_account" "storage" {
  name 			                = "${var.storage_account_name}"
  resource_group_name 	    = "${azurerm_resource_group.cluster.name}"
  location 		              = "${azurerm_resource_group.cluster.location}"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
}

resource "azurerm_storage_container" "container" {
  name 			            = "vhds"
  resource_group_name 	= "${azurerm_resource_group.cluster.name}"
  storage_account_name 	= "${azurerm_storage_account.storage.name}"
  container_access_type = "private"
}

# Network Security Group
resource "azurerm_network_security_group" "jenkins_security" {
  name 			            = "jenkins_vm_security_group"
  location 		          = "${azurerm_resource_group.cluster.location}"
  resource_group_name 	= "${azurerm_resource_group.cluster.name}"

  security_rule {
    name 			                  = "AllowSSH"
    priority 		                = 100
    direction 		              = "Inbound"
    access 		                  = "Allow"
    protocol 	  	              = "Tcp"
    source_port_range           = "*"
    destination_port_range     	= "22"
    source_address_prefix      	= "*"
    destination_address_prefix 	= "*"
  }

  security_rule {
    name 			                    = "AllowHTTP"
    priority		                  = 200
    direction		                  = "Inbound"
    access 			                  = "Allow"
    protocol 		                  = "Tcp"
    source_port_range             = "*"
    destination_port_range     	  = "8080"
    source_address_prefix      	  = "Internet"
    destination_address_prefix 	  = "*"
  }
}


# Network Interface
resource "azurerm_public_ip" "jenkins_pip" {
  name 				                  = "jenkins_pip"
  location 			                = "${azurerm_resource_group.cluster.location}"
  resource_group_name 		      = "${azurerm_resource_group.cluster.name}"
  public_ip_address_allocation 	= "static"
}

resource "azurerm_network_interface" "jenkins_public_nic" {
  name 		                  = "Jenkins_Public_NIC"
  location 	                = "${azurerm_resource_group.cluster.location}"
  resource_group_name       = "${azurerm_resource_group.cluster.name}"
  network_security_group_id = "${azurerm_network_security_group.jenkins_security.id}"

  ip_configuration {
    name 			                    = "jenkins-Private"
    subnet_id 			              = "${azurerm_subnet.jenkins_subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id	        = "${azurerm_public_ip.jenkins_pip.id}"
  }
}


# Jenkins VM
resource "azurerm_virtual_machine" "jenkins" {
  name                  = "${var.jenkins_vm_name}"
  location              = "${azurerm_resource_group.cluster.location}"
  resource_group_name   = "${azurerm_resource_group.cluster.name}"
  network_interface_ids = ["${azurerm_network_interface.jenkins_public_nic.id}"]
  vm_size               = "${var.jenkins_vm_size}"

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name          = "jenkins-osdisk"
    vhd_uri       = "${azurerm_storage_account.storage.primary_blob_endpoint}${azurerm_storage_container.container.name}/osdisk-1.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.jenkins_vm_name}"
    admin_username = "${var.admin_username}"
    custom_data   = "${data.template_cloudinit_config.initconfig.rendered}"
  }

  os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/${var.admin_username}/.ssh/authorized_keys"
            key_data = "${var.ssh_key}"
        }
    }  

}


# Script that will be executed during the VM Creation
data "template_file" "setup_jenkins_vm_script" {
  template = "${file("../../scripts/setup_jenkins.sh")}"

  vars{
    aks_kube_config="${azurerm_kubernetes_cluster.k8scluster.kube_config_raw}"
  }
}

data "template_cloudinit_config" "initconfig" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.setup_jenkins_vm_script.rendered}"
  }
}


# Creating Azure Kubernetes Service
resource "azurerm_kubernetes_cluster" "k8scluster" {
  name                = "${var.aks_name}"
  location            = "${azurerm_resource_group.cluster.location}"
  resource_group_name = "${azurerm_resource_group.cluster.name}"
  dns_prefix          = "${var.aks_dns_prefix}"

  linux_profile {
    admin_username = "${var.admin_username}"

    ssh_key {
      key_data = "${var.ssh_key}"
    }
  }

  agent_pool_profile {
    name            = "default"
    count           = 1
    vm_size         = "${var.aks_agent_vm_type}"
    os_type         = "${var.aks_agent_os_type}"
    os_disk_size_gb = 30
    vnet_subnet_id      = "${azurerm_subnet.jenkins_subnet.id}"
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  tags {
    Environment = "${var.environment_tag}"
  }
}