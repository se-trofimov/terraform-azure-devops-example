resource "azurerm_resource_group" "webapp_rg" {
  name     = "${var.environment}-webapp-rg"
  location = local.location
}
