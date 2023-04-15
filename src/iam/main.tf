resource "azurerm_resource_group" "iam_rg" {
  name     = "${var.environment}-iam-rg"
  location = var.location
}