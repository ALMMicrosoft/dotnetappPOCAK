# Production Environment - App Service on Azure
# This configuration deploys the Calculator app to Azure App Service (Production)

terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateCalculatorprod"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
      recover_soft_deleted_key_vaults = true
    }
  }
}

# Local variables
locals {
  environment = "production"
  location    = "East US"
  app_name    = "calculator-dotnet-prod"
  
  common_tags = {
    Environment = "Production"
    Project     = "Calculator"
    ManagedBy   = "Terraform"
    CostCenter  = "IT-Operations"
    CreatedDate = formatdate("YYYY-MM-DD", timestamp())
  }
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${local.app_name}"
  location = local.location

  tags = local.common_tags
}

# Networking Module with Private Endpoint
module "networking" {
  source = "../../terraform-azure-modules/networking"

  vnet_name                      = "vnet-${local.app_name}"
  location                       = azurerm_resource_group.main.location
  resource_group_name            = azurerm_resource_group.main.name
  address_space                  = ["10.1.0.0/16"]
  app_service_subnet_prefix      = ["10.1.1.0/24"]
  private_endpoint_subnet_prefix = ["10.1.2.0/24"]
  enable_private_endpoint        = true # Enabled for production security
  environment                    = local.environment

  tags = local.common_tags
}

# Security Module (Key Vault with enhanced security)
module "security" {
  source = "../../terraform-azure-modules/security"

  key_vault_name                     = "kv-${replace(local.app_name, "-", "")}"
  location                           = azurerm_resource_group.main.location
  resource_group_name                = azurerm_resource_group.main.name
  environment                        = local.environment
  enable_purge_protection            = true # Critical for production
  key_vault_network_default_action   = "Deny" # Deny all by default
  allowed_subnet_ids                 = [module.networking.app_service_subnet_id]
  app_service_principal_id           = module.app_service.app_service_identity_principal_id
  db_connection_string               = var.db_connection_string
  api_key                            = var.api_key
  app_insights_instrumentation_key   = module.app_service.application_insights_instrumentation_key
  log_retention_days                 = 365 # 1 year retention for compliance
  enable_security_center             = true
  security_contact_email             = var.security_contact_email
  security_contact_phone             = var.security_contact_phone

  tags = local.common_tags

  depends_on = [module.app_service]
}

# App Service Module (Production tier)
module "app_service" {
  source = "../../terraform-azure-modules/app-service"

  app_service_plan_name = "asp-${local.app_name}"
  app_service_name      = local.app_name
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  sku_name              = "P1v3" # Premium v3 for production
  environment           = local.environment
  always_on             = true # Always on for production
  
  allowed_origins = [
    "https://${local.app_name}.azurewebsites.net",
    "https://www.yourcustomdomain.com"
  ]

  ip_restrictions = var.ip_restrictions

  app_settings = {
    "DB_CONNECTION_STRING" = "@Microsoft.KeyVault(SecretUri=${module.security.key_vault_uri}secrets/db-connection-string/)"
    "API_KEY"              = "@Microsoft.KeyVault(SecretUri=${module.security.key_vault_uri}secrets/api-key/)"
    "ENVIRONMENT"          = "Production"
    "DEBUG_MODE"           = "false"
    "WEBSITE_TIME_ZONE"    = "Eastern Standard Time"
  }

  connection_string      = var.db_connection_string
  enable_staging_slot    = true # Blue-green deployment
  
  tags = local.common_tags
}

# Storage Account with Geo-Redundancy
resource "azurerm_storage_account" "app_data" {
  name                     = "st${replace(local.app_name, "-", "")}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "GRS" # Geo-redundant for production
  min_tls_version          = "TLS1_2"

  blob_properties {
    delete_retention_policy {
      days = 30
    }
    versioning_enabled = true
  }

  tags = local.common_tags
}

# Front Door for CDN and WAF (Optional but recommended)
resource "azurerm_cdn_frontdoor_profile" "main" {
  count               = var.enable_front_door ? 1 : 0
  name                = "fd-${local.app_name}"
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "Premium_AzureFrontDoor"

  tags = local.common_tags
}

# Autoscale Settings
resource "azurerm_monitor_autoscale_setting" "app_service" {
  name                = "autoscale-${local.app_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  target_resource_id  = module.app_service.app_service_id

  profile {
    name = "defaultProfile"

    capacity {
      default = 2
      minimum = 2
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = module.app_service.app_service_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 70
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = module.app_service.app_service_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 30
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }

  tags = local.common_tags
}
