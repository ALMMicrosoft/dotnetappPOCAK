# Outputs for Security Module

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "db_connection_string_secret_id" {
  description = "ID of the database connection string secret"
  value       = azurerm_key_vault_secret.db_connection_string.id
}

output "api_key_secret_id" {
  description = "ID of the API key secret"
  value       = azurerm_key_vault_secret.api_key.id
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.security.id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.security.name
}
