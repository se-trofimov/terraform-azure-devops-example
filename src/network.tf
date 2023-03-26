resource "azurerm_virtual_network" "eshoponweb_vnet" {
  name                = "eshoponweb-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
}

resource "azurerm_subnet" "eshoponweb_sqlserver_subnet" {
  name                 = "eshoponweb-sqlserver-subnet"
  resource_group_name  = azurerm_resource_group.webapp_rg.name
  virtual_network_name = azurerm_virtual_network.eshoponweb_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Sql"]

  delegation {
    name = "vnet-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_mssql_virtual_network_rule" "eshoponveb_sqlserver_rule" {
  name      = "eshoponveb-sqlserver-network-rule"
  server_id = azurerm_mssql_server.eshoponweb_sqlserver.id
  subnet_id = azurerm_subnet.eshoponweb_sqlserver_subnet.id
}
