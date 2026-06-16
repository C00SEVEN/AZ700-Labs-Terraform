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
  name     = "intlb-rg-eastus"
  location = var.locations.hub
  tags     = local.tags
}
  
#3. Create lb vnet
resource "azurerm_virtual_network" "intlb_vnet" {
  name                = "vnet-intlb-eastus"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.locations.hub
  address_space       = ["10.1.0.0/16"]
  tags                = local.tags
  
}

#4 Create lb subnets
resource "azurerm_subnet" "backend_subnet" {
  name                 = "snet-inlb-backend-001" 
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.intlb_vnet.name
  address_prefixes     = ["10.1.0.0/24"]
  
}
resource "azurerm_subnet" "frontend_subnet" {
  name                 = "snet-inlb-frontend-001" 
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.intlb_vnet.name
  address_prefixes     = ["10.1.2.0/24"]


}