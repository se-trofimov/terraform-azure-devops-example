terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.49.0"
    }
  }
    backend "azurerm" {
    resource_group_name  = "terraform-backend-rg"
    storage_account_name = "eshopterraformbackendsa"
    container_name       = "terraform-state-dev1-container"
    key                  = "web-application/terraform.tfstate"
    access_key           = "vnWcpTI13Nxa7+NzXcnqD8Nk/1akZB8QY6zlCzLCK/jFrYNj2JN5q/ut9plhjvTyt9qbjP8LgBho+AStDhU4tA=="
  }
}

provider "azurerm" {
  features {}
}
