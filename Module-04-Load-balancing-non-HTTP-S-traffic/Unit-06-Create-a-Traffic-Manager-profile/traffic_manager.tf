#1. Create traffic Manager Profile
resource "azurerm_traffic_manager_profile" "tm_profile1" {
  name                   = "tm-az700-lab-001"
  resource_group_name    = azurerm_resource_group.rg_us.name
  traffic_routing_method = "Performance"

  dns_config {
    relative_name = "tm-az700-lab-001"
    ttl           = 30
  }

  monitor_config {
    protocol = "HTTP"
    port     = 80
    path     = "/"
  }
  tags = local.tags
}
#2. Create traffic Manager Profile endpoints
resource "azurerm_traffic_manager_azure_endpoint" "us_enpoint1" {
  name               = "us-endpoint-dev-001"
  profile_id         = azurerm_traffic_manager_profile.tm_profile1.id
  target_resource_id = azurerm_public_ip.pip_us_vm1.id
  enabled            = true
}

resource "azurerm_traffic_manager_azure_endpoint" "eu_endpoint1" {
  name               = "eu-endpoint-dev-001"
  profile_id         = azurerm_traffic_manager_profile.tm_profile1.id
  target_resource_id = azurerm_public_ip.pip_eu_vm1.id
  enabled            = true

}

