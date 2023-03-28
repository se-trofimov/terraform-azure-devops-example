output "webapp_rg" {
   value = azurerm_resource_group.webapp_rg.name
}

output "webapp_ui_webapp_name" {
   value = azurerm_windows_web_app.eshop_ui_web_app.name
}

output "webapp_ui_deployment_slot_name" {
   value = azurerm_windows_web_app_slot.eshop_ui_web_app_slots[0].name
}