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

module "k8s-master-vm" {
  source = "./modules/linux-vm"
  security_group_id = azurerm_network_security_group.main.id
  resource_group_name = azurerm_resource_group.main.name
  subnet_id = azurerm_subnet.main.id
  adminusername = "k8s-master"
  vm_name = "k8s-master"
}

module "k8s-worker-vm" {
  source = "./modules/linux-vm"
  security_group_id = azurerm_network_security_group.main.id
  resource_group_name = azurerm_resource_group.main.name
  subnet_id = azurerm_subnet.main.id
  adminusername = "k8s-worker"
  vm_name = "k8s-worker"
}
