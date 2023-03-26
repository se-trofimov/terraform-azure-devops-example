resource "azurerm_virtual_network" "eshoponweb_vnet" {
  name                = "${var.environment}-eshoponweb-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
}

resource "azurerm_virtual_network_dns_servers" "eshoponweb_dns" {
  virtual_network_id = azurerm_virtual_network.eshoponweb_vnet.id
  dns_servers        = ["10.0.0.4"]
}

resource "azurerm_subnet" "eshoponweb_sql_server_subnet" {
  name                 = "${var.environment}-eshoponweb-sql_server_subnet"
  resource_group_name  = azurerm_resource_group.webapp_rg.name
  virtual_network_name = azurerm_virtual_network.eshoponweb_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "eshoponweb_web_app_subnet" {
  name                 = "${var.environment}-eshoponweb-web-app-subnet"
  resource_group_name  = azurerm_resource_group.webapp_rg.name
  virtual_network_name = azurerm_virtual_network.eshoponweb_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_private_dns_zone" "eshoponweb_private_dns_zone" {
  name                = "${var.environment}.eshoponweb.private.dns"
  resource_group_name = azurerm_resource_group.webapp_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "eshoponweb_private_dns_link" {
  depends_on = [
    azurerm_private_dns_zone.eshoponweb_private_dns_zone
  ]

  name                  = "${var.environment}-eshoponweb-private-dns-link"
  resource_group_name   = azurerm_resource_group.webapp_rg.name
  private_dns_zone_name = "privatelink.database.windows.net"
  virtual_network_id    = azurerm_virtual_network.eshoponweb_vnet.id
}

resource "azurerm_private_endpoint" "eshoponweb_private_endpoint" {
  name                = "${var.environment}-eshoponweb-private-endpoint"
  location            = var.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
  subnet_id           = azurerm_subnet.eshoponweb_sql_server_subnet.id
  private_service_connection {
    name                           = "${var.environment}-eshoponweb-private-connection"
    is_manual_connection           = "false"
    private_connection_resource_id = azurerm_mssql_server.eshoponweb_sqlserver.id
    subresource_names              = ["sqlServer"]
  }
}

data "azurerm_private_endpoint_connection" "eshoponweb_private_connection" {
  name                = azurerm_private_endpoint.eshoponweb_private_endpoint.name
  resource_group_name = azurerm_resource_group.webapp_rg.name
}

resource "azurerm_private_dns_a_record" "eshoponweb_endpoint_dns_a_record" {
  depends_on = [
    azurerm_private_dns_zone.eshoponweb_private_dns_zone
  ]

  name                = azurerm_mssql_server.eshoponweb_sqlserver.name
  zone_name           = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  ttl                 = 300
  records             = [data.azurerm_private_endpoint_connection.eshoponweb_private_connection.private_service_connection.0.private_ip_address]
}

resource "azurerm_app_service_virtual_network_swift_connection" "eshoponweb_webapp_vnet_integration" {
  app_service_id = azurerm_windows_web_app.eshop_ui_web_app.id
  subnet_id      = azurerm_subnet.eshoponweb_web_app_subnet.id
}
