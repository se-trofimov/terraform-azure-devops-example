resource "azurerm_service_plan" "web_app_plan" {
  name                = "${var.webapp_name}-plan"
  location            = var.webapp_location
  resource_group_name = var.resource_group_name
  os_type             = "Windows"
  sku_name            = var.webapp_plan_tier
}

resource "azurerm_windows_web_app" "web_app" {

  lifecycle { ignore_changes = [virtual_network_subnet_id] }

  name                = var.webapp_name
  location            = var.webapp_location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.web_app_plan.id

  site_config {
    application_stack {
      dotnet_version = "v7.0"
    }
    always_on = false
  }
  app_settings = var.webapp_settings

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = var.identity_ids
  }
}

resource "azurerm_windows_web_app_slot" "web_app_slots" {

  lifecycle { ignore_changes = [virtual_network_subnet_id] }

  count          = var.webapp_slots_count
  name           = "${azurerm_windows_web_app.web_app.name}-deployment-slot-${count.index + 1}"
  app_service_id = azurerm_windows_web_app.web_app.id
  app_settings   = var.webapp_settings
  site_config {}
}
