# Development Environment - App Service on Azure
# This configuration deploys the Calculator app to Azure App Service (Dev)

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
    storage_account_name = "tfstateCalculatordev"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

# Local variables
locals {
  environment = "dev"
  location    = "East US"
  app_name    = "calculator-dotnet-dev"
  
  common_tags = {
    Environment = "Development"
    Project     = "Calculator"
    ManagedBy   = "Terraform"
    CreatedDate = formatdate("YYYY-MM-DD", timestamp())
  }
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${local.app_name}"
  location = local.location

  tags = local.common_tags
}

# Networking Module
module "networking" {
  source = "../../terraform-azure-modules/networking"

  vnet_name                      = "vnet-${local.app_name}"
  location                       = azurerm_resource_group.main.location
  resource_group_name            = azurerm_resource_group.main.name
  address_space                  = ["10.0.0.0/16"]
  app_service_subnet_prefix      = ["10.0.1.0/24"]
  private_endpoint_subnet_prefix = ["10.0.2.0/24"]
  enable_private_endpoint        = false # Disabled for dev to save costs
  environment                    = local.environment

  tags = local.common_tags
}

# Security Module (Key Vault)
module "security" {
  source = "../../terraform-azure-modules/security"

  key_vault_name                     = "kv-${replace(local.app_name, "-", "")}"
  location                           = azurerm_resource_group.main.location
  resource_group_name                = azurerm_resource_group.main.name
  environment                        = local.environment
  enable_purge_protection            = false # Disabled for dev
  key_vault_network_default_action   = "Allow" # Allow for dev access
  app_service_principal_id           = module.app_service.app_service_identity_principal_id
  db_connection_string               = var.db_connection_string
  api_key                            = var.api_key
  app_insights_instrumentation_key   = module.app_service.application_insights_instrumentation_key
  log_retention_days                 = 30
  enable_security_center             = false # Disabled for dev to save costs
  security_contact_email             = var.security_contact_email

  tags = local.common_tags

  depends_on = [module.app_service]
}

# App Service Module
module "app_service" {
  source = "../../terraform-azure-modules/app-service"

  app_service_plan_name = "asp-${local.app_name}"
  app_service_name      = local.app_name
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  sku_name              = "B1" # Basic tier for dev
  environment           = local.environment
  always_on             = false # Save costs in dev
  
  allowed_origins = [
    "http://localhost:5000",
    "https://${local.app_name}.azurewebsites.net"
  ]

  app_settings = {
    "DB_CONNECTION_STRING" = "@Microsoft.KeyVault(SecretUri=${module.security.key_vault_uri}secrets/db-connection-string/)"
    "API_KEY"              = "@Microsoft.KeyVault(SecretUri=${module.security.key_vault_uri}secrets/api-key/)"
    "ENVIRONMENT"          = "Development"
    "DEBUG_MODE"           = "true"
  }

  connection_string      = var.db_connection_string
  enable_staging_slot    = false # No staging slot in dev
  
  tags = local.common_tags
}

# Storage Account for App Data (if needed)
resource "azurerm_storage_account" "app_data" {
  name                     = "st${replace(local.app_name, "-", "")}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS" # Locally redundant for dev
  min_tls_version          = "TLS1_2"

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  tags = local.common_tags
}
