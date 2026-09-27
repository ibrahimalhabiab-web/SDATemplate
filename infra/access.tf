resource "azurerm_role_assignment" "portal_storage" {
  scope                = azurerm_storage_account.uploads.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_web_app.portal.identity[0].principal_id
}

resource "azurerm_role_assignment" "processor_storage" {
  scope                = azurerm_storage_account.uploads.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_function_app.processor.identity[0].principal_id
}

resource "azurerm_role_assignment" "portal_key_vault" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_web_app.portal.identity[0].principal_id
}

resource "azurerm_role_assignment" "processor_key_vault" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_function_app.processor.identity[0].principal_id
}

resource "azurerm_role_assignment" "portal_servicebus_sender" {
  scope                = azurerm_servicebus_namespace.main.id
  role_definition_name = "Azure Service Bus Data Sender"
  principal_id         = azurerm_linux_web_app.portal.identity[0].principal_id
}

resource "azurerm_role_assignment" "processor_servicebus_receiver" {
  scope                = azurerm_servicebus_namespace.main.id
  role_definition_name = "Azure Service Bus Data Receiver"
  principal_id         = azurerm_linux_function_app.processor.identity[0].principal_id
}
