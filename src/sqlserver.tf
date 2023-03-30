resource "azurerm_mssql_server" "eshoponweb_sqlserver" {
  name                         = "${var.environment}-eshoponweb-sqlserver"
  resource_group_name          = azurerm_resource_group.webapp_rg.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.eshoponweb_sqlserver_login
  administrator_login_password = var.eshoponweb_sqlserver_password

  azuread_administrator {
    login_username = "Azure AD Admin"
    object_id      = "677a4f85-0d7f-4d11-b798-47d7a0099660"
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

resource "azurerm_mssql_virtual_network_rule" "eshoponveb_sqlserver_rule" {
  name      = "eshoponweb-sqlserver-network-rule"
  server_id = azurerm_mssql_server.eshoponweb_sqlserver.id
  subnet_id = azurerm_subnet.eshoponweb_sqlserver_subnet.id
}