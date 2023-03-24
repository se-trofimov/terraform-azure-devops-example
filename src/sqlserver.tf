resource "azurerm_sql_server" "eshoponweb_sqlserver" {
  name                         = "${var.environment}-eshoponweb-sqlserver"
  resource_group_name          = azurerm_resource_group.webapp_rg.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.eshoponweb_sqlserver_login
  administrator_login_password = var.eshoponweb_sqlserver_password
}

resource "azurerm_mssql_database" "eshoponweb_db" {
  name                        = "${var.environment}-eshoponweb-main-db"
  server_id                   = azurerm_mssql_server.eshoponweb_sqlserver.id
  collation                   = "SQL_Latin1_General_CP1_CI_AS"
  license_type                = "BasePrice"
  max_size_gb                 = 25
  min_capacity                = 0.5
  read_replica_count          = 0
  read_scale                  = false
  sku_name                    = "GP_S_Gen5_1"
  zone_redundant              = false
  auto_pause_delay_in_minutes = 60
  threat_detection_policy {
        disabled_alerts      = []
        email_account_admins = "Disabled"
        email_addresses      = []
        retention_days       = 0
        state                = "Disabled"
        use_server_default   = "Disabled"
    }
}
