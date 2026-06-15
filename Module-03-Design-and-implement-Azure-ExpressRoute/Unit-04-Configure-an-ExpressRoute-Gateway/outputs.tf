output "ExpressRoute_pip" {
  value = azurerm_public_ip.ExpressRoute_pip.ip_address
}
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "expressroute_gateway_name" {
  value = azurerm_virtual_network_gateway.CoreServicesVnetGateway.name
}

output "expressroute_gateway_id" {
  value = azurerm_virtual_network_gateway.CoreServicesVnetGateway.id
}

output "gateway_public_ip_id" {
  value = azurerm_public_ip.ExpressRoute_pip.id
}

output "gateway_subnet_id" {
  value = azurerm_subnet.gateway_hub.id
}