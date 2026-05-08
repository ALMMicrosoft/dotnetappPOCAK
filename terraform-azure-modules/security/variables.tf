# Variables for Security Module

variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "enable_purge_protection" {
  description = "Enable purge protection for Key Vault"
  type        = bool
  default     = true
}

variable "key_vault_network_default_action" {
  description = "Default action for Key Vault network ACL"
  type        = string
  default     = "Deny"
}

variable "allowed_ips" {
  description = "List of allowed IP addresses for Key Vault"
  type        = list(string)
  default     = []
}

variable "allowed_subnet_ids" {
  description = "List of allowed subnet IDs for Key Vault"
  type        = list(string)
  default     = []
}

variable "app_service_principal_id" {
  description = "Principal ID of the App Service managed identity"
  type        = string
  default     = ""
}

variable "db_connection_string" {
  description = "Database connection string to store in Key Vault"
  type        = string
  sensitive   = true
}

variable "api_key" {
  description = "API key to store in Key Vault"
  type        = string
  sensitive   = true
}

variable "app_insights_instrumentation_key" {
  description = "Application Insights instrumentation key"
  type        = string
  default     = ""
  sensitive   = true
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 90
}

variable "enable_security_center" {
  description = "Enable Azure Security Center"
  type        = bool
  default     = true
}

variable "security_contact_email" {
  description = "Email for security alerts"
  type        = string
  default     = ""
}

variable "security_contact_phone" {
  description = "Phone for security alerts"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
