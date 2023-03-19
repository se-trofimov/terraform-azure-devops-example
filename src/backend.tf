terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.47.0"
    }
    backend = {
      resource_group_name  = "__vg-terraform-backend-rg__"
      storage_account_name = "__vg-storage-account__"
      container_name       = "__container-name__"
      key                  = "terraform.tfstate"
    }
  }
}

provider "azurerm" {
  features {}
}