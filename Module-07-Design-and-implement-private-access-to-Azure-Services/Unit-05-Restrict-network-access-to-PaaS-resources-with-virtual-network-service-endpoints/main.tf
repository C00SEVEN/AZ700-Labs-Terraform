# 1. Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "core-services-rg"
  location = local.locations.sa
  tags     = local.tags
}

# 2. Create Virtual Network
resource "azurerm_virtual_network" "vnet_core" {
  name                = "CoreServicesVNet"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  tags                = local.tags
}

# 3. Create Public Subnet
resource "azurerm_subnet" "snet_public" {
  name                 = "snet-Public"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_core.name
  address_prefixes     = ["10.0.0.0/24"]
}

# 4. Create Private Subnet with Microsoft.Storage Service Endpoint enabled
resource "azurerm_subnet" "snet_private" {
  name                 = "snet-Private"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_core.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

# 5. Create Network Security Group for the Private subnet
resource "azurerm_network_security_group" "nsg_private" {
  name                = "nsg-snet-private-001"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

# 6. Create a Outbound rule — Allow traffic to Azure Storage service tag
resource "azurerm_network_security_rule" "allow_storage_all" {
  name                        = "Allow-Storage-All"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "Storage"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_private.name
}

# 7. Create a Outbound rule — Deny all traffic to Internet (overrides default allow)
resource "azurerm_network_security_rule" "deny_internet_all" {
  name                        = "Deny-Internet-All"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_private.name
}
# 8. Create a Inbound rule — Allow RDP from anywhere (lab testing only)
resource "azurerm_network_security_rule" "allow_rdp_all" {
  name                        = "Allow-RDP-All"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_private.name
}

# 9. Associate NSG to Private subnet only
resource "azurerm_subnet_network_security_group_association" "nsg_private_assoc" {
  subnet_id                 = azurerm_subnet.snet_private.id
  network_security_group_id = azurerm_network_security_group.nsg_private.id
}
# Create NSG for Public subnet
resource "azurerm_network_security_group" "nsg_public" {
  name                = "ContosoPublicNSG"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

# 10 Create NSG for Public subnet
resource "azurerm_network_security_rule" "allow_rdp_public" {
  name                        = "Allow-RDP-Public"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_public.name
}

resource "azurerm_subnet_network_security_group_association" "nsg_public_assoc" {
  subnet_id                 = azurerm_subnet.snet_public.id
  network_security_group_id = azurerm_network_security_group.nsg_public.id
}