
output "vm1_public_ip" {
  value = azurerm_public_ip.vm1_pip.ip_address
}

output "vm2_public_ip" {
  value = azurerm_public_ip.vm2_pip.ip_address
}

output "vm1_private_ip" {
  value = azurerm_network_interface.vm1_nic.private_ip_address
}

output "vm2_private_ip" {
  value = azurerm_network_interface.vm2_nic.private_ip_address
}
output "core_gateway_public_ip" {
  value = azurerm_public_ip.core_gw_pip.ip_address
}

output "mfg_gateway_public_ip" {
  value = azurerm_public_ip.mfg_gw_pip.ip_address
}

output "vpn_connection_id" {
  value = azurerm_virtual_network_gateway_connection.core_to_mfg.id
}