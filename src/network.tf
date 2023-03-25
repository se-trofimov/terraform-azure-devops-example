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
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_private_dns_zone" "eshoponweb_private_dns" {
  name = "${var.environment}-eshoponweb-private-dns"
  resource_group_name = azurerm_resource_group.webapp_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "eshoponweb_private_dns_link" {
  name = "${var.environment}-eshoponweb-private-dns-link"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.eshoponweb_private_dns.name
  virtual_network_id = azurerm_virtual_network.eshoponweb_vnet.id
}
