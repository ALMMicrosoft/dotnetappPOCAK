# Variables for App Service Module

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
}

variable "app_service_name" {
  description = "Name of the App Service"
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

variable "sku_name" {
  description = "SKU name for App Service Plan (e.g., B1, S1, P1v2)"
  type        = string
  default     = "B1"
}

variable "environment" {
  description = "Environment name (dev, staging, production)"
  type        = string
}

variable "always_on" {
  description = "Keep the app always on"
  type        = bool
  default     = true
}

variable "allowed_origins" {
  description = "List of allowed CORS origins"
  type        = list(string)
  default     = []
}

variable "ip_restrictions" {
  description = "List of IP restrictions"
  type = list(object({
    name       = string
    ip_address = string
    priority   = number
  }))
  default = []
}

variable "app_settings" {
  description = "Application settings"
  type        = map(string)
  default     = {}
}

variable "connection_string" {
  description = "Database connection string"
  type        = string
  sensitive   = true
}

variable "enable_staging_slot" {
  description = "Enable staging slot for blue-green deployment"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
