data "azurerm_client_config" "current" {}

resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-tasreeh-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 90
  tags                = local.common_tags
}

resource "azurerm_application_insights" "main" {
  name                = "appi-tasreeh-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = "web"
  tags                = local.common_tags
}

resource "azurerm_service_plan" "web" {
  name                   = "asp-tasreeh-${var.environment}"
  location               = azurerm_resource_group.main.location
  resource_group_name    = azurerm_resource_group.main.name
  os_type                = "Linux"
  sku_name               = var.environment == "prod" ? "P1v3" : "B1"
  zone_balancing_enabled = var.environment == "prod"
  tags                   = local.common_tags
}

resource "azurerm_linux_web_app" "portal" {
  name                      = "app-${var.project_prefix}-${var.environment}"
  location                  = azurerm_resource_group.main.location
  resource_group_name       = azurerm_resource_group.main.name
  service_plan_id           = azurerm_service_plan.web.id
  https_only                = true
  virtual_network_subnet_id = azurerm_subnet.app.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on           = var.environment == "prod"
    ftps_state          = "Disabled"
    minimum_tls_version = "1.2"

    application_stack {
      python_version = "3.11"
    }

    ip_restriction {
      action      = "Allow"
      name        = "Allow-Azure-Front-Door"
      priority    = 100
      service_tag = "AzureFrontDoor.Backend"
    }
  }

  app_settings = {
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.main.connection_string
    SQL_SERVER_FQDN                       = azurerm_mssql_server.main.fully_qualified_domain_name
    UPLOAD_STORAGE_ACCOUNT                = azurerm_storage_account.uploads.name
    SERVICE_BUS_NAMESPACE                 = azurerm_servicebus_namespace.main.name
  }

  tags = local.common_tags
}

resource "azurerm_service_plan" "functions" {
  name                = "asp-tasreeh-functions-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "EP1"
  tags                = local.common_tags
}

resource "azurerm_linux_function_app" "processor" {
  name                        = "func-${var.project_prefix}-${var.environment}"
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  service_plan_id             = azurerm_service_plan.functions.id
  storage_account_name        = azurerm_storage_account.uploads.name
  storage_account_access_key  = azurerm_storage_account.uploads.primary_access_key
  https_only                  = true
  virtual_network_subnet_id   = azurerm_subnet.app.id
  functions_extension_version = "~4"

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_insights_connection_string = azurerm_application_insights.main.connection_string
    minimum_tls_version                    = "1.2"

    application_stack {
      python_version = "3.11"
    }
  }

  app_settings = {
    SQL_SERVER_FQDN       = azurerm_mssql_server.main.fully_qualified_domain_name
    SERVICE_BUS_NAMESPACE = azurerm_servicebus_namespace.main.name
  }

  tags = local.common_tags
}

resource "azurerm_servicebus_namespace" "main" {
  name                          = "sb-${var.project_prefix}-${var.environment}"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  sku                           = "Premium"
  capacity                      = 1
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false
  tags                          = local.common_tags
}

resource "azurerm_servicebus_queue" "document_processing" {
  name         = "document-processing"
  namespace_id = azurerm_servicebus_namespace.main.id

  dead_lettering_on_message_expiration = true
  default_message_ttl                  = "PT10M"
  max_delivery_count                   = 5
}
