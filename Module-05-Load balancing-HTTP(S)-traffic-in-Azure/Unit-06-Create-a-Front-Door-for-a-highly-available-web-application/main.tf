#1 Create resource group
resource "azurerm_resource_group" "rg_ac" {
  name     = "az700-rg-dev-ac"
  location = local.locations.ac
  tags     = local.tags
}

resource "azurerm_resource_group" "rg_ae" {
  name     = "az700-rg-dev-ae"
  location = local.locations.ae
  tags     = local.tags
}

#2 Create app service plan
resource "azurerm_service_plan" "ac_asp" {
  name                = "asp-ac-dev-001"
  location            = local.locations.ac
  resource_group_name = azurerm_resource_group.rg_ac.name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_service_plan" "ae_asp" {
  name                = "asp-ae-dev-001"
  location            = local.locations.ae
  resource_group_name = azurerm_resource_group.rg_ae.name
  os_type             = "Linux"
  sku_name            = "B1"
}