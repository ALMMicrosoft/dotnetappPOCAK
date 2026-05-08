# Variables for Production Environment

variable "db_connection_string" {
  description = "Database connection string - MUST be stored in Azure Key Vault"
  type        = string
  sensitive   = true
}

variable "api_key" {
  description = "API key for the application - MUST be stored in Azure Key Vault"
  type        = string
  sensitive   = true
}

variable "security_contact_email" {
  description = "Email address for security notifications"
  type        = string
}

variable "security_contact_phone" {
  description = "Phone number for security notifications"
  type        = string
}

variable "ip_restrictions" {
  description = "List of IP restrictions for App Service"
  type = list(object({
    name       = string
    ip_address = string
    priority   = number
  }))
  default = [
    {
      name       = "AllowCorporateNetwork"
      ip_address = "203.0.113.0/24"
      priority   = 100
    }
  ]
}

variable "enable_front_door" {
  description = "Enable Azure Front Door for CDN and WAF"
  type        = bool
  default     = false
}
