output "webapp_rg" {
   value = azurerm_resource_group.network_rg.name
}

output "eshoponweb_sqlserver_subnet" {
   value = azurerm_subnet.eshoponweb_sqlserver_subnet.name
}