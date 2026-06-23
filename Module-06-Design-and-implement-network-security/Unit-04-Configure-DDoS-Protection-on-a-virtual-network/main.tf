#1. create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "az700-rg-dev-ddos"
  location = local.locations.us
  tags     = local.tags
}

# 2. Create DDoS Protection Plan
resource "azurerm_network_ddos_protection_plan" "ddos_plan" {
  name                = "ddos-az700-dev-001"
  location            = local.locations.us
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

#3. Create Virtual Network with DDoS protection enabled
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-az700-ddos-dev"
  location            = local.locations.us
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.ddos_plan.id
    enable = true
  }

  tags = local.tags
}

# 3.1 Create Subnet
resource "azurerm_subnet" "snet_app" {
  name                 = "snet-app-dev-001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

# 4. Create Public IP for telemetry
resource "azurerm_public_ip" "pip_ddos" {
  name                = "pip-az700-ddos-dev-001"
  location            = local.locations.us
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "az700ddos"
  tags                = local.tags
}