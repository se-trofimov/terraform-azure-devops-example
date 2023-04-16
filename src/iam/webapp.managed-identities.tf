resource "azurerm_user_assigned_identity" "webapp_identity" {
  location            = var.location
  name                = "web-app-${var.environment}-ua-identity"
  resource_group_name = azurerm_resource_group.iam_rg.name
}


resource "mssql_user" "example" {
  server {
    host = "dev1-eshoponweb-sqlserver.database.windows.net"
    azure_login {
    }
  }

  database  = "dev1-eshoponweb-identity-db"
  username  = azurerm_user_assigned_identity.webapp_identity.name
  object_id = azurerm_user_assigned_identity.webapp_identity.client_id

  roles     = ["db_datareader"]
}