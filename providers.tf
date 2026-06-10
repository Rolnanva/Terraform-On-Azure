terraform {
  backend "azurerm" {
    resource_group_name = "terraform-state-rg"
    storage_account_name = "tfstaterolan001"
    container_name = "tfstate"
    key = "project1.tfstate"
  }
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 3.0"
    }
  }
  required_version = ">= 1.6.0"
}

provider "azurerm" {
  features {
    
  }
}