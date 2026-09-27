output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "vnet_name" {
  value = azurerm_virtual_network.main.name
}

output "storage_account_name" {
  value = azurerm_storage_account.uploads.name
}

output "portal_default_hostname" {
  value = azurerm_linux_web_app.portal.default_hostname
}

output "front_door_endpoint_hostname" {
  value = azurerm_cdn_frontdoor_endpoint.main.host_name
}

output "sql_server_fqdn" {
  value = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "key_vault_name" {
  value = azurerm_key_vault.main.name
}

output "service_bus_namespace" {
  value = azurerm_servicebus_namespace.main.name
}
