locals {
  environments = ["dev1", "dev2", "stage", "production"]
}

resource "azurerm_resource_group" "terraform_backend_rg" {
  name     = "terraform-backend-rg"
  location = "West Europe"
}

resource "azurerm_storage_account" "terraform_backend_sa" {
  name                     = "eshopterraformbackendsa"
  resource_group_name      = azurerm_resource_group.terraform_backend_rg.name
  location                 = azurerm_resource_group.terraform_backend_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_container" "terraform_backend_container" {
  for_each              = toset(local.environments)
  name                  = "terraform-state-${each.key}-container"
  storage_account_name  = azurerm_storage_account.terraform_backend_sa.name
  container_access_type = "private"
}
