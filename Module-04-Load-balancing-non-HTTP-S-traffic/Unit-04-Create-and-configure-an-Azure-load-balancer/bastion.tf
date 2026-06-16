resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.intlb_vnet.name
  address_prefixes     = ["10.1.1.0/27"] 

}

resource "azurerm_public_ip" "bastion_pip" {
  name                = "bastion-pip-eastus-001"
  location            = var.locations.hub
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bastion-eastus-001"
  location            = var.locations.hub
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
    tags = local.tags
}
