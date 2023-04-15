resource "azurerm_user_assigned_identity" "webapp_identity" {
  location            = var.location
  name                = "web-app-${var.environment}-ua-identity"
  resource_group_name = azurerm_resource_group.iam_rg.name
}