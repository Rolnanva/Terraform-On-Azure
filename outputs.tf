output "resource_group_name" {
  description = "The name of the resource group"
  value = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "the location of the resource group"
  value = azurerm_resource_group.main.location
}

output "public_ips" {
  value = {
    for key, ip in azurerm_public_ip.main :
    key => ip.ip_address
  }
}