resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${local.resource_suffix}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "snet" {
  name                 = "snet-${local.resource_suffix}-01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_private_endpoint" "sql_endpoint" {
  name                = "pep-sql-${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.snet.id
  tags                = local.default_tags

  private_service_connection {
    name                           = azurerm_mssql_server.sqlserver.name
    private_connection_resource_id = azurerm_mssql_server.sqlserver.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }
}

resource "azurerm_private_endpoint" "kv_enpoint" {
  name                = "pep-kv-${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.snet.id
  tags                = local.default_tags

  private_service_connection {
    name                           = azurerm_key_vault.kv.name
    private_connection_resource_id = azurerm_key_vault.kv.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }
}

resource "azurerm_private_endpoint" "sa_enpoint" {
  name                = "pep-sa-${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.snet.id
  tags                = local.default_tags

  private_service_connection {
    name                           = azurerm_storage_account.sa.name
    private_connection_resource_id = azurerm_storage_account.sa.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}

resource "azurerm_private_endpoint" "appcfg_enpoint" {
  name                = "pep-appcfg-${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.snet.id
  tags                = local.default_tags

  private_service_connection {
    name                           = azurerm_app_configuration.appconf.name
    private_connection_resource_id = azurerm_app_configuration.appconf.id
    is_manual_connection           = false
    subresource_names              = ["configurationStores"]
  }
}
