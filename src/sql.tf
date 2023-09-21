resource "azurerm_mssql_server" "sqlserver" {
  name                         = "sqls-${local.resource_suffix}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = local.sql_admin_name
  administrator_login_password = random_password.sql_password.result

  tags = local.default_tags
}

resource "azurerm_mssql_database" "sqldb" {
  name           = "sqldb-${local.resource_suffix}"
  server_id      = azurerm_mssql_server.sqlserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 4
  read_scale     = true
  sku_name       = "S0"
  zone_redundant = false

  tags = local.default_tags
}
