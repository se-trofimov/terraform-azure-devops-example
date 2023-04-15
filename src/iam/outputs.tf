output "webapp_identity" {
  value = azurerm_user_assigned_identity.webapp_identity.id
}

output "sqladmin_identity" {
  value = azurerm_user_assigned_identity.sqladmin_identity.id
}