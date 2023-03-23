resource "azurerm_resource_group" "webapp_rg" {
  name     = "${var.environment}-webapp-rg"
  location = var.location
}

resource "azurerm_service_plan" "eshop_web_ui_plan" {
  name                = "${var.environment}-eshop-web-ui-plan"
  location            = var.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
  os_type             = "Windows"
  sku_name            = var.eshopwebapp_ui_plan_tier
}

resource "azurerm_windows_web_app" "eshop_ui_web_app" {
  name                = "${var.environment}-eshop-web-ui-webapp"
  location            = var.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
  service_plan_id     = azurerm_service_plan.eshop_web_ui_plan.id

  site_config {
    application_stack {
      dotnet_version = "v7.0"
    }
    always_on = var.eshopwebapp_ui_plan_tier == "D1" ? false : true
  }

  app_settings = var.eshop_ui_web_app_settings
}
