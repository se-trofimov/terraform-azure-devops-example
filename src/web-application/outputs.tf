output "webapp_ui_webapp_name" {
   value = azurerm_windows_web_app.eshop_ui_web_app.name
}


output "eshop_admin_web_app_name" {
   value = azurerm_windows_web_app.eshop_admin_web_app.name
}

output "webapp_ui_webapp_deployment_slot_name" {
   value = azurerm_windows_web_app_slot.eshop_ui_web_app_slots[*].name
}

output "webapp_ui_resource_group_name" {
   value = azurerm_resource_group.webapp_rg.name
}