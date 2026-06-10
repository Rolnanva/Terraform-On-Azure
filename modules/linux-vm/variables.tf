variable "vm_name" {
  type = string
  description = "the name of the vm"
}

variable "vm_size" {
  type = string
  description = "which vm type is it"
  default = "Standard_B2ls_v2"
}

variable "subnet_id" {
  type = string
  description = "the subnet id for the subnet"
}

variable "resource_group_name" {
  type = string
  description = "resource group name"
}

variable "location" {
  type = string
  default = "westeurope"
}

variable "adminusername" {
  type = string
}

variable "ssh_public_key" {
  type = string
  default = "C:\\Users\\rolan.nanvazadeh/.ssh/id_rsa.pub"
}

variable "security_group_id" {
  type = string
}