resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${local.resource_suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "ai" {
  name                = "ai-${local.resource_suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  workspace_id        = azurerm_log_analytics_workspace.law.id
  application_type    = "web"

  tags = local.default_tags
}

resource "azurerm_service_plan" "asp" {
  name                = "asp-${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Windows"
  sku_name            = "Y1"

  tags = local.default_tags
}

resource "azurerm_windows_function_app" "fa" {
  name                = "fa-${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  service_plan_id            = azurerm_service_plan.asp.id

  site_config {
    minimum_tls_version = "1.2"
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = azurerm_application_insights.ai.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = azurerm_application_insights.ai.connection_string
    "ASPNETCORE_ENVIRONMENT"                     = var.environment
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~2"
  }

  connection_string {
    name  = "AppConfig"
    type  = "Custom"
    value = azurerm_app_configuration.appconf.primary_read_key.0.connection_string
  }

  tags = local.default_tags

}
