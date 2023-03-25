resource "azurerm_virtual_network" "eshoponweb_vnet" {
  name                = "${var.environment}-eshoponweb-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
}

resource "azurerm_subnet" "eshoponweb_subnet" {
  name                 = "${var.environment}-eshoponweb-subnet"
  resource_group_name  = azurerm_resource_group.webapp_rg.name
  virtual_network_name = azurerm_virtual_network.eshoponweb_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_app_service_virtual_network_swift_connection" "eshoponweb_vnet_connection" {
  app_service_id = azurerm_windows_web_app.eshop_ui_web_app.id
  subnet_id      = azurerm_subnet.eshoponweb_subnet.id
}