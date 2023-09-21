resource "azurerm_key_vault" "kv" {
  name                        = "kv-${local.resource_suffix}"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }

  tags = local.default_tags
}

resource "azurerm_key_vault_secret" "sql_password" {
  name         = "${azurerm_mssql_server.sqlserver.name}-admin-pass"
  value        = random_password.sql_password.result
  key_vault_id = azurerm_key_vault.kv.id

  tags = local.default_tags
}

resource "azurerm_key_vault_secret" "sql_db_connection_string" {
  name         = "${azurerm_mssql_database.sqldb.name}-connection-string"
  value        = "Server=tcp:${azurerm_mssql_server.sqlserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.sqldb.name};Persist Security Info=False;User ID=${local.sql_admin_name};Password=${random_password.sql_password.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  key_vault_id = azurerm_key_vault.kv.id

  tags = local.default_tags
}
