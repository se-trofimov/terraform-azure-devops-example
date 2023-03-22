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

resource "azurerm_linux_web_app" "eshop_ui_web_app" {
  name                = "${var.environment}-eshop-web-ui-webapp"
  location            = var.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
  service_plan_id     = azurerm_service_plan.eshop_web_ui_plan.id
  
  site_config {
    application_stack {
        dotnet_version  = "7.0"
      }
  }
}
