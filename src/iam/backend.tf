terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.49.0"
    }
    mssql = {
      source  = "betr-io/mssql"
      version = "0.2.7"
    }
  }
  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}
}
