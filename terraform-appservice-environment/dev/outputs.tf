# Outputs for Development Environment

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "app_service_url" {
  description = "URL of the App Service"
  value       = "https://${module.app_service.app_service_default_hostname}"
}

output "app_service_name" {
  description = "Name of the App Service"
  value       = module.app_service.app_service_name
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.security.key_vault_name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.security.key_vault_uri
}

output "application_insights_instrumentation_key" {
  description = "Application Insights instrumentation key"
  value       = module.app_service.application_insights_instrumentation_key
  sensitive   = true
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.app_data.name
}

output "deployment_command" {
  description = "Azure CLI command to deploy the app"
  value       = "az webapp deployment source config-zip --resource-group ${azurerm_resource_group.main.name} --name ${module.app_service.app_service_name} --src <path-to-zip>"
}
