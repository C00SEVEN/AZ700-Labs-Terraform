output "traffic_manager_fqdn" {
  value = azurerm_traffic_manager_profile.tm_profile1.fqdn
}

output "app_us_fqdn" {
  value = azurerm_public_ip.pip_us_vm1.fqdn
}

output "app_eu_fqdn" {
  value = azurerm_public_ip.pip_eu_vm1.fqdn
}