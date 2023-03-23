output "webapp_rg" {
   value = azurerm_resource_group.webapp_rg.name
}

output "webapp_ui_webapp_name" {
   value = azurerm_windows_web_app.eshop_ui_web_app.name
}