# Azure App Service Module
# This module creates an Azure App Service for hosting .NET applications

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# App Service Plan
resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Windows"
  sku_name            = var.sku_name

  tags = merge(
    var.tags,
    {
      "Module"      = "app-service"
      "Environment" = var.environment
    }
  )
}

# App Service
resource "azurerm_windows_web_app" "main" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    always_on = var.always_on
    
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v4.0" # .NET Framework 4.8
    }

    # Security headers
    http2_enabled = true
    
    cors {
      allowed_origins     = var.allowed_origins
      support_credentials = false
    }

    # IP restrictions
    dynamic "ip_restriction" {
      for_each = var.ip_restrictions
      content {
        name       = ip_restriction.value.name
        ip_address = ip_restriction.value.ip_address
        action     = "Allow"
        priority   = ip_restriction.value.priority
      }
    }
  }

  app_settings = merge(
    {
      "WEBSITE_RUN_FROM_PACKAGE" = "1"
      "ASPNETCORE_ENVIRONMENT"   = var.environment
    },
    var.app_settings
  )

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = var.connection_string
  }

  # Enable HTTPS only
  https_only = true

  # Identity for Key Vault access
  identity {
    type = "SystemAssigned"
  }

  tags = merge(
    var.tags,
    {
      "Module"      = "app-service"
      "Environment" = var.environment
    }
  )
}

# App Service Slot for Blue-Green deployment
resource "azurerm_windows_web_app_slot" "staging" {
  count          = var.enable_staging_slot ? 1 : 0
  name           = "staging"
  app_service_id = azurerm_windows_web_app.main.id

  site_config {
    always_on = var.always_on
    
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v4.0"
    }

    http2_enabled = true
  }

  app_settings = merge(
    {
      "WEBSITE_RUN_FROM_PACKAGE" = "1"
      "ASPNETCORE_ENVIRONMENT"   = "${var.environment}-staging"
    },
    var.app_settings
  )

  https_only = true

  identity {
    type = "SystemAssigned"
  }

  tags = merge(
    var.tags,
    {
      "Module"      = "app-service"
      "Environment" = "${var.environment}-staging"
      "Slot"        = "staging"
    }
  )
}

# Application Insights
resource "azurerm_application_insights" "main" {
  name                = "${var.app_service_name}-insights"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"

  tags = merge(
    var.tags,
    {
      "Module"      = "app-service"
      "Environment" = var.environment
    }
  )
}

# Add Application Insights to App Service
resource "azurerm_windows_web_app_application_settings" "insights" {
  app_service_id = azurerm_windows_web_app.main.id

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = azurerm_application_insights.main.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = azurerm_application_insights.main.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
  }
}
