# 1 Create Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-intlb-eastus-001"
  location            = var.locations.hub
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}

# 2 Configure Diagnostic Settings on the Load Balancer
resource "azurerm_monitor_diagnostic_setting" "lb_diagnostics" {
  name                       = "diag-lb-eastus-001"
  target_resource_id         = azurerm_lb.internal_lb.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}