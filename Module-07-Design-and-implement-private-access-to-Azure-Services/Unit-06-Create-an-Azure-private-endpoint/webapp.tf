# 1. Create App Service Plan
resource "azurerm_service_plan" "asp" {
  name                = "aps-sa-unit6-1"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Windows"
  sku_name            = "P2v2"
  tags                = local.tags
}

# 2. Create Web App
resource "azurerm_windows_web_app" "webapp" {
  name                = "webappaz700001"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {}
  public_network_access_enabled = false

  tags = local.tags
}
