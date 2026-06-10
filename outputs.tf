output "resource_group_name" {
  description = "The name of the resource group"
  value = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "the location of the resource group"
  value = azurerm_resource_group.main.location
}

output "public_ips" {
 value = "Master: ${module.k8s-master-vm.public_ip_address}\n Worker: ${module.k8s-worker-vm.public_ip_address}"
}