#1. Create Log Analytics Workspace 
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-az700-ddos-dev-001"
  location            = local.locations.us
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}

#2. Create Monitoring Diagnostic settings on Public IP 
resource "azurerm_monitor_diagnostic_setting" "pip_diag" {
  name                       = "diag-ddos-pip-001"
  target_resource_id         = azurerm_public_ip.pip_ddos.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "DDoSProtectionNotifications"
  }
  enabled_log {
    category = "DDoSMitigationFlowLogs"
  }
  enabled_log {
    category = "DDoSMitigationReports"
  }
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# 3.Create Alert rule
resource "azurerm_monitor_metric_alert" "ddos_alert" {
  name                = "alert-ddos-az700-dev-001"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_public_ip.pip_ddos.id]
  description         = "Alert when Public IP is under DDoS attack"
  severity            = 1
  enabled             = true

  criteria {
    metric_namespace = "Microsoft.Network/publicIPAddresses"
    metric_name      = "IfUnderDDoSAttack"
    aggregation      = "Maximum"
    operator         = "GreaterThanOrEqual"
    threshold        = 1
  }

  tags = local.tags
}