#1 Create tags
locals {
  tags = {
    environment = "dev"
    project     = "az700-labs"
    managed_by  = "terraform"
    topology    = "hub-and-spoke"
  }
}
#2. Create a Resource Group 
resource "azurerm_resource_group" "rg" {
  name     = "rg-contoso-connectivity-shared-eastus"
  location = var.locations.hub
  tags     = local.tags
}
  
#3. Create Hub vnet
resource "azurerm_virtual_network" "core_services_vnet" {
  name                = "vnet-hub-core-eastus"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.locations.hub
  address_space       = ["10.20.0.0/16"]
  tags                = local.tags
  }

#3.1 Create Hub subnets
resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet" 
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.core_services_vnet.name
  address_prefixes     = ["10.20.0.0/27"]
}

resource "azurerm_subnet" "shared_services" {
  name                 = "snet-hub-sharedservices-001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.core_services_vnet.name
  address_prefixes     = ["10.20.10.0/24"]
}

resource "azurerm_subnet" "database" {
  name                 = "snet-hub-database-001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.core_services_vnet.name
  address_prefixes     = ["10.20.20.0/24"]
}

resource "azurerm_subnet" "public_web" {
  name                 = "snet-hub-publicweb-001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.core_services_vnet.name
  address_prefixes     = ["10.20.30.0/24"]
}

#4. Create Manufacturing vnet 
resource "azurerm_virtual_network" "manufacturing_vnet" {
  name                = "vnet-spoke-manufacturing-westeurope"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.locations.spoke_manufacturing
  address_space       = ["10.30.0.0/16"]
  tags = local.tags
}

#4.1 Create Manufacturing Subnets 
resource "azurerm_subnet" "manufacturing_system" {
  name                 = "snet-mfg-system-001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.manufacturing_vnet.name
  address_prefixes     = ["10.30.10.0/24"]
}

resource "azurerm_subnet" "sensor_1" {
  name                 = "snet-mfg-sensor-001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.manufacturing_vnet.name
  address_prefixes     = ["10.30.20.0/24"]
}

resource "azurerm_subnet" "sensor_2" {
  name                 = "snet-mfg-sensor-002"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.manufacturing_vnet.name
  address_prefixes     = ["10.30.21.0/24"]
}

resource "azurerm_subnet" "sensor_3" {
  name                 = "snet-mfg-sensor-003"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.manufacturing_vnet.name
  address_prefixes     = ["10.30.22.0/24"]
}

#5. Create Research vnet 
resource "azurerm_virtual_network" "research_vnet" {
  name                = "vnet-spoke-research-southeastasia"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.locations.spoke_research
  address_space       = ["10.40.0.0/16"]
  tags = local.tags
}
#5.1 Create Research subnets 
resource "azurerm_subnet" "research_system" {
  name                 = "snet-research-system-001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.research_vnet.name
  address_prefixes     = ["10.40.0.0/24"]
}