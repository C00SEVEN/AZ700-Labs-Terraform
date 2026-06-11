output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "hub_vnet_id" {
  value = azurerm_virtual_network.core_services_vnet.id
}

output "manufacturing_vnet_id" {
  value = azurerm_virtual_network.manufacturing_vnet.id
}

output "research_vnet_id" {
  value = azurerm_virtual_network.research_vnet.id
}

output "hub_shared_services_subnet_id" {
  value = azurerm_subnet.shared_services.id
}