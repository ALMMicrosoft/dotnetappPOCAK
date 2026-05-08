# Azure Security Module - Key Vault, Secrets, and Security Policies

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

data "azurerm_client_config" "current" {}

# Key Vault for storing secrets
resource "azurerm_key_vault" "main" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 90
  purge_protection_enabled    = var.enable_purge_protection
  sku_name                    = "standard"

  # Network ACLs
  network_acls {
    bypass                     = "AzureServices"
    default_action             = var.key_vault_network_default_action
    ip_rules                   = var.allowed_ips
    virtual_network_subnet_ids = var.allowed_subnet_ids
  }

  tags = merge(
    var.tags,
    {
      "Module"      = "security"
      "Environment" = var.environment
    }
  )
}

# Access Policy for App Service
resource "azurerm_key_vault_access_policy" "app_service" {
  count        = var.app_service_principal_id != "" ? 1 : 0
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.app_service_principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

# Access Policy for Terraform/DevOps
resource "azurerm_key_vault_access_policy" "terraform" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Purge",
    "Recover"
  ]

  certificate_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Delete",
    "Purge"
  ]
}

# Store Database Connection String
resource "azurerm_key_vault_secret" "db_connection_string" {
  name         = "db-connection-string"
  value        = var.db_connection_string
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_key_vault_access_policy.terraform]

  tags = merge(
    var.tags,
    {
      "Purpose" = "Database Connection"
    }
  )
}

# Store API Key
resource "azurerm_key_vault_secret" "api_key" {
  name         = "api-key"
  value        = var.api_key
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_key_vault_access_policy.terraform]

  tags = merge(
    var.tags,
    {
      "Purpose" = "API Authentication"
    }
  )
}

# Application Insights Instrumentation Key
resource "azurerm_key_vault_secret" "app_insights_key" {
  count        = var.app_insights_instrumentation_key != "" ? 1 : 0
  name         = "app-insights-instrumentation-key"
  value        = var.app_insights_instrumentation_key
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_key_vault_access_policy.terraform]

  tags = merge(
    var.tags,
    {
      "Purpose" = "Monitoring"
    }
  )
}

# Log Analytics Workspace for Security Monitoring
resource "azurerm_log_analytics_workspace" "security" {
  name                = "${var.key_vault_name}-logs"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days

  tags = merge(
    var.tags,
    {
      "Module"      = "security"
      "Environment" = var.environment
      "Purpose"     = "Security Monitoring"
    }
  )
}

# Diagnostic Settings for Key Vault
resource "azurerm_monitor_diagnostic_setting" "key_vault" {
  name                       = "${var.key_vault_name}-diagnostics"
  target_resource_id         = azurerm_key_vault.main.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.security.id

  enabled_log {
    category = "AuditEvent"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Security Center Contact
resource "azurerm_security_center_contact" "main" {
  count = var.enable_security_center ? 1 : 0

  email               = var.security_contact_email
  phone               = var.security_contact_phone
  alert_notifications = true
  alerts_to_admins    = true
}

# Enable Azure Defender for App Services
resource "azurerm_security_center_subscription_pricing" "app_services" {
  count         = var.enable_security_center ? 1 : 0
  tier          = "Standard"
  resource_type = "AppServices"
}
