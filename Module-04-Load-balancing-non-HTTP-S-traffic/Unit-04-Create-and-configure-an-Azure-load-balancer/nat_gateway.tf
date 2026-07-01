resource "azurerm_nat_gateway" "nat" {
  name                = "nat-gw"
  location            = var.locations.hub
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_public_ip" "nat_pip" {
  name                = "nat-pip"
  location            = var.locations.hub
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_subnet_nat_gateway_association" "backend_nat" {
  subnet_id      = azurerm_subnet.backend_subnet.id
  nat_gateway_id  = azurerm_nat_gateway.nat.id
}

resource "azurerm_nat_gateway_public_ip_association" "example" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat_pip.id
}