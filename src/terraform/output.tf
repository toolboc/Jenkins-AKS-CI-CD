
# AKS Output
output "aks_resource_id" {
    value = "${azurerm_kubernetes_cluster.k8scluster.id}"
}

output "kube_config" {
  value = "${azurerm_kubernetes_cluster.k8scluster.kube_config_raw}"
}

output "client_key" {
  value = "${azurerm_kubernetes_cluster.k8scluster.kube_config.0.client_key}"
}

output "client_certificate" {
  value = "${azurerm_kubernetes_cluster.k8scluster.kube_config.0.client_certificate}"
}

output "cluster_ca_certificate" {
  value = "${azurerm_kubernetes_cluster.k8scluster.kube_config.0.cluster_ca_certificate}"
}

output "host" {
  value = "${azurerm_kubernetes_cluster.k8scluster.kube_config.0.host}"
}

output "admin_username" {
  value = "${var.admin_username}"
}

output "jenkins_pip" {
  value = "${azurerm_public_ip.jenkins_pip.ip_address}"
}

