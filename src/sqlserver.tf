resource "azurerm_mssql_server" "eshoponweb_sqlserver" {
  name                         = "eshoponweb-sqlserver"
  resource_group_name          = azurerm_resource_group.webapp_rg.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.eshoponweb_sqlserver_login
  administrator_login_password = var.eshoponweb_sqlserver_password
  minimum_tls_version          = "1.2"

  azuread_administrator {
    login_username = "Azure AD Admin"
    object_id      = "677a4f85-0d7f-4d11-b798-47d7a0099660"
  }

  tags = {
    environment = "production"
  }
}