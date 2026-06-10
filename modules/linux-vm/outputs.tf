output "public_ip_address" {
  value = "${azurerm_linux_virtual_machine.main.admin_username}:${azurerm_linux_virtual_machine.main.public_ip_address}"
}

output "private_ip_address" {
  value = azurerm_linux_virtual_machine.main.private_ip_address
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.main.id
}