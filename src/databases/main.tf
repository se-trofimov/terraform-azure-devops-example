data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "sql_rg" {
  name     = "${var.environment}-databases-rg"
  location = var.location
}

resource "azurerm_mssql_server" "eshoponweb_sqlserver" {
  name                         = "${var.environment}-eshoponweb-sqlserver"
  resource_group_name          = azurerm_resource_group.sql_rg.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.eshoponweb_sqlserver_login
  administrator_login_password = var.eshoponweb_sqlserver_password
  azuread_administrator {
    login_username = "Azure AD Admin"
    object_id      = data.azurerm_client_config.current.object_id
  }
}

resource "azurerm_mssql_database" "eshoponweb_db" {
  name                        = "${var.environment}-eshoponweb-main-db"
  server_id                   = azurerm_mssql_server.eshoponweb_sqlserver.id
  collation                   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb                 = var.eshoponweb_sqlserver_max_size_gb
  sku_name                    = var.eshoponweb_sqlserver_sku
  zone_redundant              = false
  geo_backup_enabled          = false
  storage_account_type        = "Local"
  min_capacity                = var.eshoponweb_sqlserver_sku == "Basic" ? 0 : 0.5
  auto_pause_delay_in_minutes = var.eshoponweb_sqlserver_sku == "Basic" ? 0 : 60
}

resource "azurerm_mssql_database" "eshoponweb_identity_db" {
  name                        = "${var.environment}-eshoponweb-identity-db"
  server_id                   = azurerm_mssql_server.eshoponweb_sqlserver.id
  collation                   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb                 = var.eshoponweb_sqlserver_max_size_gb
  sku_name                    = var.eshoponweb_sqlserver_sku
  zone_redundant              = false
  storage_account_type        = "Local"
  min_capacity                = var.eshoponweb_sqlserver_sku == "Basic" ? 0 : 0.5
  auto_pause_delay_in_minutes = var.eshoponweb_sqlserver_sku == "Basic" ? 0 : 60
}