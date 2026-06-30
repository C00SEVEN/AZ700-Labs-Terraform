# 1. Create Private Endpoint 
resource "azurerm_private_endpoint" "pe_webapp" {
  name                = "pe-webapp-sa-unit6-1"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.snet_backend.id

  private_service_connection {
    name                           = "pe-connection-webapp"
    private_connection_resource_id = azurerm_windows_web_app.webapp.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "Group-unit6-dns"
    private_dns_zone_ids = [azurerm_private_dns_zone.dns_zone.id]
  }
    depends_on = [
      azurerm_private_dns_zone.dns_zone,
      azurerm_private_dns_zone_virtual_network_link.dns_link
  ]

  tags = local.tags
}

# 2. Create Private DNS Zone
resource "azurerm_private_dns_zone" "dns_zone" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

# 3. Link Private DNS Zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  name                  = "dns-link-unit6-vnet"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  tags                  = local.tags
  
}
