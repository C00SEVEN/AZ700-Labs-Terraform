# 1. Front Door profile
resource "azurerm_cdn_frontdoor_profile" "fd_profile" {
  name                = "fd-az700-lab-001"
  resource_group_name = azurerm_resource_group.rg_ac.name
  sku_name            = "Standard_AzureFrontDoor"
  tags                = local.tags
}

resource "azurerm_cdn_frontdoor_endpoint" "fd_endpoint" {
  name                     = "fd-az700-lab-001"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
  tags                     = local.tags
}

resource "azurerm_cdn_frontdoor_origin_group" "fd_og" {
  name                     = "og-az700-webapps"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    path                = "/"
    protocol            = "Https"
    interval_in_seconds = 30
  }
}

resource "azurerm_cdn_frontdoor_origin" "origin_ac" {
  name                          = "origin-webapp-ac"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_og.id

  # origin_host_header mact match app's own hostname — fixes the 404 we discacsed
  host_name                     = azurerm_linux_web_app.ac_app1.default_hostname
  http_port                     = 80
  https_port                    = 443
  priority                      = 1
  weight                        = 1000
  enabled                       = true
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_origin" "origin_ae" {
  name                          = "origin-webapp-ae"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_og.id

  host_name                     = azurerm_linux_web_app.ae_app1.default_hostname
  http_port                     = 80
  https_port                    = 443
  priority                      = 2
  weight                        = 1000
  enabled                       = true
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_route" "fd_route" {
  name                          = "route-az700-001"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_og.id
  cdn_frontdoor_origin_ids = [
    azurerm_cdn_frontdoor_origin.origin_ac.id,
    azurerm_cdn_frontdoor_origin.origin_ae.id
  ]

  supported_protocols    = ["Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true
  enabled                = true
}