resource "azurerm_virtual_network" "eshoponweb_vnet" {
  name                = "${var.environment}-eshoponweb_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
}

resource "azurerm_subnet" "eshoponweb_subnet" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.webapp_rg.name
  virtual_network_name = azurerm_virtual_network.eshoponweb_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}