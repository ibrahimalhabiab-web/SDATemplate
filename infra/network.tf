# -----------------------------------------------------------------------
# This file follows the boundary pattern taught in Module 3:
#   resource group > VNet > two subnets (app, private endpoints)
#   PaaS services live OUTSIDE the VNet and are reached through a
#   private endpoint in the private-endpoint subnet.
#
# It uses one placeholder PaaS resource (a storage account) so the
# skeleton is small and always valid. Replace or add resources
# (Azure SQL, Key Vault, Service Bus, ...) to match YOUR physical
# diagram — the pattern (private endpoint + private DNS zone) is the
# same for each of them.
# -----------------------------------------------------------------------

resource "azurerm_virtual_network" "main" {
  name                = "vnet-tasreeh-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = var.vnet_address_space
  tags                = local.common_tags
}

resource "azurerm_subnet" "app" {
  name                 = "snet-app"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.app_subnet_prefix

  delegation {
    name = "app-service-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "pe" {
  name                 = "snet-pe"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.pe_subnet_prefix

  # Required so private endpoints can be created in this subnet.
  private_endpoint_network_policies = "Disabled"
}

# -----------------------------------------------------------------------
# Placeholder PaaS service: a Storage Account, reached only through a
# private endpoint. Swap this for (or add) Azure SQL, Key Vault, etc.
# following the same private endpoint + private DNS zone pattern.
# -----------------------------------------------------------------------

resource "azurerm_storage_account" "uploads" {
  name                = replace("st${var.project_prefix}${var.environment}", "-", "")
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  account_tier                    = "Standard"
  account_replication_type        = "ZRS"
  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false

  tags = local.common_tags
}

resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                  = "link-blob-${var.environment}"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.main.id
}

resource "azurerm_private_endpoint" "uploads_blob" {
  name                = "pe-uploads-blob-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.pe.id

  private_service_connection {
    name                           = "psc-uploads-blob"
    private_connection_resource_id = azurerm_storage_account.uploads.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }

  tags = local.common_tags
}
