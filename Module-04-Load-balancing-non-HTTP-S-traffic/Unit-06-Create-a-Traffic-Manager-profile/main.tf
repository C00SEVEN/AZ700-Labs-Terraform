
#1. Create a Resource Group App US 
resource "azurerm_resource_group" "rg_us" {
  name     = "az700-rg-dev-eastus"
  location = local.locations.us
  tags     = local.tags
}
#2. Create a Resource Group Ap West Europe
resource "azurerm_resource_group" "rg_eu" {
  name     = "az700-rg-dev-westeurope"
  location = local.locations.eu
  tags     = local.tags
}

#3. Create US hub vnets
resource "azurerm_virtual_network" "vnet_eastus" {
  name                = "vnet-hub-eastus"
  resource_group_name = azurerm_resource_group.rg_us.name
  location            = local.locations.us
  address_space       = ["10.0.0.0/16"]
  tags                = local.tags
  }

#3.1 Create US Hub subnets
resource "azurerm_subnet" "snet_us_app" {
  name                 = "snet-app_eastus_001" 
  resource_group_name  = azurerm_resource_group.rg_us.name
  virtual_network_name = azurerm_virtual_network.vnet_eastus.name
  address_prefixes     = ["10.0.0.0/27"]
}

#4. Create EU hub vnets
resource "azurerm_virtual_network" "vnet_westeurope" {
  name                = "vnet-hub-westeurope"
  resource_group_name = azurerm_resource_group.rg_eu.name
  location            = local.locations.eu
  address_space       = ["10.1.0.0/16"]
  tags                = local.tags
  }

#4.1 Create EU Hub subnets
resource "azurerm_subnet" "snet_eu_app" {
  name                 = "snet-app_westeurope_001" 
  resource_group_name  = azurerm_resource_group.rg_eu.name
  virtual_network_name = azurerm_virtual_network.vnet_westeurope.name
  address_prefixes     = ["10.1.0.0/27"]
}

#5.Create NSGs and associations
resource "azurerm_network_security_group" "nsg_us" {
  name                = "nsg-us-dev-001"
  location            = local.locations.us
  resource_group_name = azurerm_resource_group.rg_us.name

  security_rule {
    name                       = "allow-http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = local.tags
}


resource "azurerm_network_security_group" "nsg_eu" {
  name                = "nsg-us-dev-001"
  location            = local.locations.eu
  resource_group_name = azurerm_resource_group.rg_eu.name

  security_rule {
    name                       = "allow-http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = local.tags
}

resource "azurerm_subnet_network_security_group_association" "nsg_us_assoc" {
  subnet_id                 = azurerm_subnet.snet_us_app.id
  network_security_group_id = azurerm_network_security_group.nsg_us.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_eu_assoc" {
  subnet_id                 = azurerm_subnet.snet_eu_app.id
  network_security_group_id = azurerm_network_security_group.nsg_eu.id
}