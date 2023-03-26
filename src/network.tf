resource "azurerm_virtual_network" "eshoponweb_vnet" {
  name                = "${var.environment}-eshoponweb-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
}

resource "azurerm_subnet" "eshoponweb_subnet" {
  name                                           = "${var.environment}-eshoponweb-subnet"
  resource_group_name                            = azurerm_resource_group.webapp_rg.name
  virtual_network_name                           = azurerm_virtual_network.eshoponweb_vnet.name
  address_prefixes                               = ["10.0.1.0/24"]
  delegation {
    name = "example-delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
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
  private_dns_zone_name = azurerm_private_dns_zone.eshoponweb_private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.eshoponweb_vnet.id
}

resource "azurerm_private_endpoint" "eshoponweb_private_endpoint" {
  name                = "${var.environment}-eshoponweb-private-endpoint"
  location            = var.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
  subnet_id           = azurerm_subnet.eshoponweb_subnet.id
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

  name                = lower(azurerm_mssql_server.eshoponweb_sqlserver.name)
  zone_name           = azurerm_private_dns_zone.eshoponweb_private_dns_zone.name
  resource_group_name = azurerm_resource_group.webapp_rg.name
  ttl                 = 300
  records             = [data.azurerm_private_endpoint_connection.eshoponweb_private_connection.private_service_connection.0.private_ip_address]
}
