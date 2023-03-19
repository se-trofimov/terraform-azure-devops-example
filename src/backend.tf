terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.47.0"
    }
    backend = {
      resource_group_name  = "__resource_group_name__"
      storage_account_name = "__storage_account_name__"
      container_name       = "__container_name__"
      key                  = "terraform.tfstate"
    }
  }
}

provider "azurerm" {
  features {}
}
