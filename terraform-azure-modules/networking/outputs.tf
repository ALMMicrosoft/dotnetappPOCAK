# Outputs for Networking Module

output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.main.name
}

output "app_service_subnet_id" {
  description = "ID of the App Service subnet"
  value       = azurerm_subnet.app_service.id
}

output "private_endpoint_subnet_id" {
  description = "ID of the Private Endpoint subnet"
  value       = azurerm_subnet.private_endpoints.id
}

output "nsg_id" {
  description = "ID of the Network Security Group"
  value       = azurerm_network_security_group.app_service.id
}

output "private_dns_zone_id" {
  description = "ID of the Private DNS Zone"
  value       = var.enable_private_endpoint ? azurerm_private_dns_zone.app_service[0].id : null
}
