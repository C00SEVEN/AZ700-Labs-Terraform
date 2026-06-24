#1. Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "Test-FW-RG"
  location = local.locations.sa
  tags     = local.tags
}

#2. Create Vnet and Snets
resource "azurerm_virtual_network" "vnet_fw" {
  name                = "vnet-test-fw-sa-001"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  tags                = local.tags
}

resource "azurerm_subnet" "snet_firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_fw.name
  address_prefixes     = ["10.0.1.0/26"]
}

resource "azurerm_subnet" "snet_workload" {
  name                 = "snet-wload-fw-sa-001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_fw.name
  address_prefixes     = ["10.0.2.0/24"]
}