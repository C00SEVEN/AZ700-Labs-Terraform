resource "azurerm_application_gateway" "app_gw_contoso" {
  name                = "appgw-az700-lab-001"
  location            = local.locations.us
  resource_group_name = azurerm_resource_group.rg_us.name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }
   ssl_policy {                             
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20220101"
  }

  gateway_ip_configuration {
    name      = "appgw-ip-configuration"
    subnet_id = azurerm_subnet.snet_contososervices.id
  }

  frontend_port {
    name = "fe-port001"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "fe-ip-configuration"
    public_ip_address_id = azurerm_public_ip.pip_us_appgw.id
  }

  backend_address_pool {
    name = "backend001"
  }

  backend_http_settings {
    name                  = "backend-http001"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60

    probe_name = "http-probe001"
    pick_host_name_from_backend_address = true
  }

  probe {
    name                = "http-probe001"
    protocol            = "Http"
    path                = "/"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    pick_host_name_from_backend_http_settings = true
  }

  http_listener {
    name                           = "listener001"
    frontend_ip_configuration_name = "fe-ip-configuration"
    frontend_port_name             = "fe-port001"
    protocol                       = "Http"

  }

  request_routing_rule {
    name                       = "rule001"
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = "listener001"
    backend_address_pool_name  = "backend001"
    backend_http_settings_name = "backend-http001"
  }

  tags = local.tags
}