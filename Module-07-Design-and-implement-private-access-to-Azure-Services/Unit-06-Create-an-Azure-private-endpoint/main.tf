# 1. Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-sa-unit6-1"
  location = local.locations.sa
  tags     = local.tags
}

# 2. Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-sa-unit6-1"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  tags                = local.tags
}

# 3. Create Backend Subnet 
resource "azurerm_subnet" "snet_backend" {
  name                 = "snet-backend-sa-unit6-1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]

  private_endpoint_network_policies = "Disabled"
}

# 4. Create Bastion Subnet
resource "azurerm_subnet" "snet_bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 5. Create Public IP for Bastion
resource "azurerm_public_ip" "pip_bastion" {
  name                = "pip-bastion-sa-unit6-1"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

# 6. Create Bastion Host
resource "azurerm_bastion_host" "bastion" {
  name                = "bastion-sa-unit6-1"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.snet_bastion.id
    public_ip_address_id = azurerm_public_ip.pip_bastion.id
  }

  tags = local.tags
}
