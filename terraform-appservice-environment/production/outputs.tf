# Outputs for Production Environment

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

output "staging_slot_url" {
  description = "URL of the staging slot"
  value       = "https://${module.app_service.staging_slot_hostname}"
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

output "deployment_commands" {
  description = "Commands for deploying the application"
  value = {
    staging_deployment = "az webapp deployment source config-zip --resource-group ${azurerm_resource_group.main.name} --name ${module.app_service.app_service_name} --slot staging --src <path-to-zip>"
    swap_slots         = "az webapp deployment slot swap --resource-group ${azurerm_resource_group.main.name} --name ${module.app_service.app_service_name} --slot staging --target-slot production"
    production_direct  = "az webapp deployment source config-zip --resource-group ${azurerm_resource_group.main.name} --name ${module.app_service.app_service_name} --src <path-to-zip>"
  }
}

output "monitoring_dashboard_url" {
  description = "URL to the Azure Portal monitoring dashboard"
  value       = "https://portal.azure.com/#@/resource${module.app_service.app_service_id}/overview"
}
