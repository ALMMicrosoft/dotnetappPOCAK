# Variables for Networking Module

variable "vnet_name" {
  description = "Name of the Virtual Network"
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

variable "address_space" {
  description = "Address space for the VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "app_service_subnet_prefix" {
  description = "Address prefix for App Service subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_endpoint_subnet_prefix" {
  description = "Address prefix for Private Endpoint subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint for App Service"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
