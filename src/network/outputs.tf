output eshoponweb_sqlserver_subnet_ids{
    value = azurerm_subnet.eshoponweb_sqlserver_subnets[*].id
}