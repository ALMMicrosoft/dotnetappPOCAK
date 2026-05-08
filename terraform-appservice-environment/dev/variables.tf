# Variables for Development Environment

variable "db_connection_string" {
  description = "Database connection string"
  type        = string
  sensitive   = true
  default     = "Server=localhost;Database=Calculator;Integrated Security=true;"
}

variable "api_key" {
  description = "API key for the application"
  type        = string
  sensitive   = true
  default     = "dev-api-key-change-in-production"
}

variable "security_contact_email" {
  description = "Email address for security notifications"
  type        = string
  default     = "security@example.com"
}

variable "allowed_ip_addresses" {
  description = "List of IP addresses allowed to access the Key Vault"
  type        = list(string)
  default     = []
}
