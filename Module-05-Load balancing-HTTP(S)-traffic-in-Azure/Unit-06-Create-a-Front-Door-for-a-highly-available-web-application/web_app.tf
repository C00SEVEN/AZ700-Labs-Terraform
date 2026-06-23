#1 Create web apps
resource "azurerm_linux_web_app" "ac_app1" {
  name                = "az700-webapp-ac-dev-001"
  location            = local.locations.ac
  resource_group_name = azurerm_resource_group.rg_ac.name
  service_plan_id     = azurerm_service_plan.ac_asp.id

  site_config {
    always_on = false
    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    REGION = "Aactralia Central"
  }

  tags = local.tags
}

resource "azurerm_linux_web_app" "ae_app1" {
  name                = "az700-webapp-ae-dev-001"
  location            = local.locations.ae
  resource_group_name = azurerm_resource_group.rg_ae.name
  service_plan_id     = azurerm_service_plan.ae_asp.id

  site_config {
    always_on = false
    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    REGION = "Aactralia East"
  }

  tags = local.tags
}