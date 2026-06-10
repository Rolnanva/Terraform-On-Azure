variable "project_name" {
  type = string
  description = "Name prefic for all resources in this project"
  default = "devops-lab"
}

variable "location" {
  type = string
  description = "Azure region for all resources"
  default = "westeurope"
}

variable "vm_size" {
  type = string
  description = "Azure VM size for both nodes"
  default = "Standard_B2s"
}