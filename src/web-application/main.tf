data "terraform_remote_state" "database" {
  backend = "azurerm"
  config = {
    resource_group_name  = "terraform-backend-rg"
    storage_account_name = "eshopterraformbackendsa"
    container_name       = "terraform-state-${var.environment}-container"
    key                  = "databases/terraform.tfstate"
  }
}

data "terraform_remote_state" "network" {
  backend = "azurerm"
  config = {
    resource_group_name  = "terraform-backend-rg"
    storage_account_name = "eshopterraformbackendsa"
    container_name       = "terraform-state-${var.environment}-container"
    key                  = "network/terraform.tfstate"
  }
}

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

  lifecycle { ignore_changes = [virtual_network_subnet_id] }

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
  connection_string {
    name  = "CatalogConnection"
    type  = "SQLAzure"
    value = "Server=tcp:${data.terraform_remote_state.database.outputs.eshoponweb_sqlserver_fully_qualified_domain_name},1433;Initial Catalog=${data.terraform_remote_state.database.outputs.eshoponweb_db_name};Persist Security Info=False;User ID=${var.eshoponweb_sqlserver_login};Password=${var.eshoponweb_sqlserver_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

  connection_string {
    name  = "IdentityConnection"
    type  = "SQLAzure"
    value = "Server=tcp:${data.terraform_remote_state.database.outputs.eshoponweb_sqlserver_fully_qualified_domain_name},1433;Initial Catalog=${data.terraform_remote_state.database.outputs.eshoponweb_identity_db_name};Persist Security Info=False;User ID=${var.eshoponweb_sqlserver_login};Password=${var.eshoponweb_sqlserver_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

  app_settings = merge(
    {
      baseUrls__apiBase = "${azurerm_windows_web_app.eshop_admin_web_app.name}.azurewebsites.net"
  }, var.eshop_ui_web_app_settings)
}

resource "azurerm_windows_web_app_slot" "eshop_ui_web_app_slots" {

  lifecycle { ignore_changes = [virtual_network_subnet_id] }

  count          = var.eshopwebapp_ui_plan_tier == "S1" ? 2 : 0
  name           = "${azurerm_windows_web_app.eshop_ui_web_app.name}-slot-${count.index}"
  app_service_id = azurerm_windows_web_app.eshop_ui_web_app.id
  app_settings = merge(
    {
      baseUrls__apiBase = "${azurerm_windows_web_app.eshop_admin_web_app.name}.azurewebsites.net"
  }, var.eshop_ui_web_app_settings)
  site_config {}
  connection_string {
    name  = "CatalogConnection"
    type  = "SQLAzure"
    value = "Server=tcp:${data.terraform_remote_state.database.outputs.eshoponweb_sqlserver_fully_qualified_domain_name},1433;Initial Catalog=${data.terraform_remote_state.database.outputs.eshoponweb_db_name};Persist Security Info=False;User ID=${var.eshoponweb_sqlserver_login};Password=${var.eshoponweb_sqlserver_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

  connection_string {
    name  = "IdentityConnection"
    type  = "SQLAzure"
    value = "Server=tcp:${data.terraform_remote_state.database.outputs.eshoponweb_sqlserver_fully_qualified_domain_name},1433;Initial Catalog=${data.terraform_remote_state.database.outputs.eshoponweb_identity_db_name};Persist Security Info=False;User ID=${var.eshoponweb_sqlserver_login};Password=${var.eshoponweb_sqlserver_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "eshoponweb_ui_swift_connection" {
  app_service_id = azurerm_windows_web_app.eshop_ui_web_app.id
  subnet_id      = data.terraform_remote_state.network.outputs.eshoponweb_sqlserver_subnet_ids[0]
}

resource "azurerm_app_service_slot_virtual_network_swift_connection" "eshoponweb_slots_ui_swift_connection" {
  count          = length(azurerm_windows_web_app_slot.eshop_ui_web_app_slots)
  slot_name      = azurerm_windows_web_app_slot.eshop_ui_web_app_slots[count.index].name
  app_service_id = azurerm_windows_web_app.eshop_ui_web_app.id
  subnet_id      = data.terraform_remote_state.network.outputs.eshoponweb_sqlserver_subnet_ids[0]
}

resource "azurerm_service_plan" "eshop_admin_web_plan" {
  name                = "${var.environment}-eshop-admin-web-plan"
  location            = var.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
  os_type             = "Windows"
  sku_name            = var.eshopwebapp_admin_plan_tier
}

resource "azurerm_windows_web_app" "eshop_admin_web_app" {

  lifecycle { ignore_changes = [virtual_network_subnet_id] }

  name                = "${var.environment}-eshop-web-admin-webapp"
  location            = var.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
  service_plan_id     = azurerm_service_plan.eshop_admin_web_plan.id

  site_config {
    application_stack {
      dotnet_version = "v7.0"
    }
    always_on = var.eshopwebapp_admin_plan_tier == "D1" ? false : true
  }

  connection_string {
    name  = "CatalogConnection"
    type  = "SQLAzure"
    value = "Server=tcp:${data.terraform_remote_state.database.outputs.eshoponweb_sqlserver_fully_qualified_domain_name},1433;Initial Catalog=${data.terraform_remote_state.database.outputs.eshoponweb_db_name};Persist Security Info=False;User ID=${var.eshoponweb_sqlserver_login};Password=${var.eshoponweb_sqlserver_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

  connection_string {
    name  = "IdentityConnection"
    type  = "SQLAzure"
    value = "Server=tcp:${data.terraform_remote_state.database.outputs.eshoponweb_sqlserver_fully_qualified_domain_name},1433;Initial Catalog=${data.terraform_remote_state.database.outputs.eshoponweb_identity_db_name};Persist Security Info=False;User ID=${var.eshoponweb_sqlserver_login};Password=${var.eshoponweb_sqlserver_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

  app_settings = merge(
    {

  }, var.eshop_admin_web_app_settings)
}

resource "azurerm_app_service_virtual_network_swift_connection" "eshoponweb_admin_swift_connection" {
  app_service_id = azurerm_windows_web_app.eshop_admin_web_app.id
  subnet_id      = data.terraform_remote_state.network.outputs.eshoponweb_sqlserver_subnet_ids[1]
}
