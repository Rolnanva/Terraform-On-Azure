resource "azurerm_resource_group" "main" {
  name = "${var.project_name}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  address_space = [ "10.0.0.0/16" ]
  resource_group_name = azurerm_resource_group.main.name
  name = "${var.project_name}-vn"
  location = var.location
}

resource "azurerm_subnet" "main" {
  resource_group_name = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes = [ "10.0.1.0/24" ]
  name = "${var.project_name}-subnet"
}

resource "azurerm_network_security_group" "main" {
  location = var.location
  name = "${var.project_name}-sg"
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name = "Allow_SSH"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

locals {
    VM_Names = {
        master = "k8s-master"
        worker = "k8s-worker"
    }
  
}

resource "azurerm_public_ip" "main" {
    for_each = local.VM_Names
    name = "${each.value}-Ip"
    resource_group_name = azurerm_resource_group.main.name
    location = var.location
    allocation_method = "Static"
    sku = "Standard"
}

resource "azurerm_network_interface" "main" {
  for_each = local.VM_Names
  name = "${each.value}-nic"
  location = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name = "${each.value}-ipconf"
    subnet_id = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.main[each.key].id
  }
}

resource "azurerm_network_interface_security_group_association" "main" {
  for_each = local.VM_Names

  network_interface_id      = azurerm_network_interface.main[each.key].id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_linux_virtual_machine" "main" {
    for_each = local.VM_Names
    name = "${each.value}-VM"
    resource_group_name = azurerm_resource_group.main.name
    location = var.location
    size = var.vm_size
    admin_username = "adminusername"
    disable_password_authentication = true
    network_interface_ids = [ azurerm_network_interface.main[each.key].id, ]

    admin_ssh_key {
      username = "adminusername"
      public_key = file("C:\\Users\\rolan.nanvazadeh/.ssh/id_rsa.pub")
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

