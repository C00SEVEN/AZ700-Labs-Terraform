output "ddos_protection_plan_id" {
  value = azurerm_network_ddos_protection_plan.ddos_plan.id
}

output "public_ip_fqdn" {
  value = azurerm_public_ip.pip_ddos.fqdn
}

output "public_ip_address" {
  value = azurerm_public_ip.pip_ddos.ip_address
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.law.id
}