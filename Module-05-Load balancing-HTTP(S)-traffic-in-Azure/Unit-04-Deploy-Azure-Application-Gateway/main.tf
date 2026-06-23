
#1. Create a Resource Group App US 
resource "azurerm_resource_group" "rg_us" {
  name     = "az700-rg-dev-eastus"
  location = local.locations.us
  tags     = local.tags
}

#2. Create Contoso vnet
resource "azurerm_virtual_network" "vnet_contoso" {
  name                = "vnet-contoso-eastus"
  resource_group_name = azurerm_resource_group.rg_us.name
  location            = local.locations.us
  address_space       = ["10.0.0.0/16"]
  tags                = local.tags
  }

#2.1 Create subnets
resource "azurerm_subnet" "snet_contososervices" {
  name                 = "snet-ag-eastus-001" 
  resource_group_name  = azurerm_resource_group.rg_us.name
  virtual_network_name = azurerm_virtual_network.vnet_contoso.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "snet_backend" {
  name                 = "snet-backend-eastus-001" 
  resource_group_name  = azurerm_resource_group.rg_us.name
  virtual_network_name = azurerm_virtual_network.vnet_contoso.name
  address_prefixes     = ["10.0.1.0/24"]
}

#3.Create NSGs and associations
resource "azurerm_network_security_group" "nsg_backend" {
  name                = "nsg-backend-001"
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
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"
  }
  tags = local.tags
}

resource "azurerm_subnet_network_security_group_association" "nsg_us_assoc" {
  subnet_id                 = azurerm_subnet.snet_backend.id
  network_security_group_id = azurerm_network_security_group.nsg_backend.id
}