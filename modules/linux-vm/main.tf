resource "azurerm_public_ip" "main" {
    name = "${var.vm_name}-Ip"
    resource_group_name = var.resource_group_name
    location = var.location
    allocation_method = "Static"
    sku = "Standard"
}

resource "azurerm_network_interface" "main" {
  name = "${var.vm_name}-nic"
  location = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name = "${var.resource_group_name}-ipconf"
    subnet_id = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.main.id
  }
}

resource "azurerm_network_interface_security_group_association" "main" {

  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = var.security_group_id
}

resource "azurerm_linux_virtual_machine" "main" {
    name = "${var.vm_name}-VM"
    resource_group_name = var.resource_group_name
    location = var.location
    size = var.vm_size
    admin_username = var.adminusername
    disable_password_authentication = true
    network_interface_ids = [ azurerm_network_interface.main.id, ]

    admin_ssh_key {
      username = var.adminusername
      public_key = file(var.ssh_public_key)
    }

    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-jammy"
        sku = "22_04-lts"
        version = "latest"
    } 
  
}
