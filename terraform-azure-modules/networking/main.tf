# Azure Virtual Network Module for App Service Integration

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space

  tags = merge(
    var.tags,
    {
      "Module"      = "networking"
      "Environment" = var.environment
    }
  )
}

# Subnet for App Service Integration
resource "azurerm_subnet" "app_service" {
  name                 = "snet-appservice"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.app_service_subnet_prefix

  delegation {
    name = "app-service-delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Subnet for Private Endpoints
resource "azurerm_subnet" "private_endpoints" {
  name                 = "snet-privateendpoints"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.private_endpoint_subnet_prefix

  private_endpoint_network_policies_enabled = false
}

# Network Security Group for App Service Subnet
resource "azurerm_network_security_group" "app_service" {
  name                = "${var.vnet_name}-appservice-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allow HTTPS inbound
  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow HTTP (will be redirected to HTTPS by App Service)
  security_rule {
    name                       = "AllowHTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Deny all other inbound
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = merge(
    var.tags,
    {
      "Module"      = "networking"
      "Environment" = var.environment
    }
  )
}

# Associate NSG with App Service Subnet
resource "azurerm_subnet_network_security_group_association" "app_service" {
  subnet_id                 = azurerm_subnet.app_service.id
  network_security_group_id = azurerm_network_security_group.app_service.id
}

# Private DNS Zone for App Service
resource "azurerm_private_dns_zone" "app_service" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.resource_group_name

  tags = merge(
    var.tags,
    {
      "Module"      = "networking"
      "Environment" = var.environment
    }
  )
}

# Link Private DNS Zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "app_service" {
  count                 = var.enable_private_endpoint ? 1 : 0
  name                  = "${var.vnet_name}-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.app_service[0].name
  virtual_network_id    = azurerm_virtual_network.main.id

  tags = merge(
    var.tags,
    {
      "Module"      = "networking"
      "Environment" = var.environment
    }
  )
}
