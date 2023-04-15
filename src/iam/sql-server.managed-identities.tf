resource "azurerm_user_assigned_identity" "sqladmin_identity" {
  location            = var.location
  name                = "eshoponweb-sqlserver-${var.environment}-ua-identity"
  resource_group_name = azurerm_resource_group.iam_rg.name
}