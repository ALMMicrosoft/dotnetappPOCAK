# Outputs for App Service Module

output "app_service_id" {
  description = "ID of the App Service"
  value       = azurerm_windows_web_app.main.id
}

output "app_service_name" {
  description = "Name of the App Service"
  value       = azurerm_windows_web_app.main.name
}

output "app_service_default_hostname" {
  description = "Default hostname of the App Service"
  value       = azurerm_windows_web_app.main.default_hostname
}

output "app_service_outbound_ips" {
  description = "Outbound IP addresses of the App Service"
  value       = azurerm_windows_web_app.main.outbound_ip_addresses
}

output "app_service_identity_principal_id" {
  description = "Principal ID of the App Service managed identity"
  value       = azurerm_windows_web_app.main.identity[0].principal_id
}

output "application_insights_instrumentation_key" {
  description = "Application Insights instrumentation key"
  value       = azurerm_application_insights.main.instrumentation_key
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "Application Insights connection string"
  value       = azurerm_application_insights.main.connection_string
  sensitive   = true
}

output "staging_slot_hostname" {
  description = "Hostname of the staging slot"
  value       = var.enable_staging_slot ? azurerm_windows_web_app_slot.staging[0].default_hostname : null
}
