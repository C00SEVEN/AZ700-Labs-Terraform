output "private_endpoint_ip" {
  description = "Private IP assigned to the Private Endpoint NIC — DNS should resolve webapp FQDN to this"
  value       = azurerm_private_endpoint.pe_webapp.private_service_connection[0].private_ip_address
}

output "webapp_hostname" {
  description = "Default hostname of the Web App"
  value       = azurerm_windows_web_app.webapp.default_hostname
}

output "vm_private_ip" {
  description = "Private IP of the test VM — access via Bastion"
  value       = azurerm_network_interface.nic_vm.private_ip_address
}

output "bastion_public_ip" {
  description = "Public IP of the Bastion host"
  value       = azurerm_public_ip.pip_bastion.ip_address
}
