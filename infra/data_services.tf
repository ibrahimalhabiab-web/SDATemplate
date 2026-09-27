resource "azurerm_mssql_server" "main" {
  name                          = "sql-${var.project_prefix}-${var.environment}"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  version                       = "12.0"
  administrator_login           = var.sql_admin_login
  administrator_login_password  = var.sql_admin_password
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false
  tags                          = local.common_tags
}

resource "azurerm_mssql_database" "permits" {
  name           = "sqldb-tasreeh-${var.environment}"
  server_id      = azurerm_mssql_server.main.id
  sku_name       = var.environment == "prod" ? "GP_S_Gen5_2" : "Basic"
  max_size_gb    = var.environment == "prod" ? 32 : 2
  zone_redundant = var.environment == "prod"
  tags           = local.common_tags
}

resource "azurerm_key_vault" "main" {
  name                          = "kv-${replace(var.project_prefix, "-", "")}-${var.environment}"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  enable_rbac_authorization     = true
  public_network_access_enabled = false
  purge_protection_enabled      = var.environment == "prod"
  soft_delete_retention_days    = 7
  tags                          = local.common_tags
}

locals {
  private_services = {
    sql = {
      zone_name         = "privatelink.database.windows.net"
      resource_id       = azurerm_mssql_server.main.id
      subresource_names = ["sqlServer"]
      connection_name   = "psc-sql"
    }
    vault = {
      zone_name         = "privatelink.vaultcore.azure.net"
      resource_id       = azurerm_key_vault.main.id
      subresource_names = ["vault"]
      connection_name   = "psc-key-vault"
    }
    servicebus = {
      zone_name         = "privatelink.servicebus.windows.net"
      resource_id       = azurerm_servicebus_namespace.main.id
      subresource_names = ["namespace"]
      connection_name   = "psc-service-bus"
    }
  }
}

resource "azurerm_private_dns_zone" "services" {
  for_each = local.private_services

  name                = each.value.zone_name
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "services" {
  for_each = local.private_services

  name                  = "link-${each.key}-${var.environment}"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.services[each.key].name
  virtual_network_id    = azurerm_virtual_network.main.id
  tags                  = local.common_tags
}

resource "azurerm_private_endpoint" "services" {
  for_each = local.private_services

  name                = "pe-${each.key}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.pe.id

  private_service_connection {
    name                           = each.value.connection_name
    private_connection_resource_id = each.value.resource_id
    subresource_names              = each.value.subresource_names
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.services[each.key].id]
  }

  tags = local.common_tags
}
