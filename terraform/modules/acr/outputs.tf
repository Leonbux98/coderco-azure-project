output "acr_id"            { value = azurerm_container_registry.acr.id }
output "acr_login_server"  { value = azurerm_container_registry.acr.login_server }
output "acr_principal_id"  { value = azurerm_container_registry.acr.identity[0].principal_id }
