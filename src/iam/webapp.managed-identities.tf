resource "azurerm_user_assigned_identity" "webapp_identity" {
  location            = var.location
  name                = "web-app-${var.environment}-ua-identity"
  resource_group_name = azurerm_resource_group.iam_rg.name
}

data "azurerm_client_config" "current" {}

resource "mssql_user" "example" {
  server {
    host = "dev1-eshoponweb-sqlserver.database.windows.net"
    azure_login {
      tenant_id     = data.azurerm_client_config.current.tenant_id
      client_id     = data.azurerm_client_config.current.client_id
      client_secret = var.client_secret
    }
  }

  database  = "dev1-eshoponweb-identity-db"
  username  = azurerm_user_assigned_identity.webapp_identity.name
  object_id = azurerm_user_assigned_identity.webapp_identity.client_id

  roles = ["db_datareader"]
}
