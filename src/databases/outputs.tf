output eshoponweb_sqlserver_fully_qualified_domain_name {
    value = azurerm_mssql_server.eshoponweb_sqlserver.fully_qualified_domain_name
 }

output eshoponweb_db_name {
    value = azurerm_mssql_database.eshoponweb_db.name
 }

output eshoponweb_identity_db_name {
    value = azurerm_mssql_database.eshoponweb_identity_db.name
 }