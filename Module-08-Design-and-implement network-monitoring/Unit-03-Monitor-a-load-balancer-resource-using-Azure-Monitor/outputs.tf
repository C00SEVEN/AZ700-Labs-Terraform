output "lb_private_ip" {
  value = azurerm_lb.internal_lb.frontend_ip_configuration[0].private_ip_address
}
output "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID — used to verify diagnostic settings"
  value       = azurerm_log_analytics_workspace.law.id
}