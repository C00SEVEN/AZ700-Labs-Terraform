resource "azurerm_lb" "internal_lb" {
  name                = "lb-eastus-001"
  location            = var.locations.hub
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "LoadBalancerFrontEnd"
    subnet_id                     = azurerm_subnet.frontend_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
   tags = local.tags
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name            = "backendpool-001"
  loadbalancer_id = azurerm_lb.internal_lb.id
}

resource "azurerm_lb_probe" "http_probe" {
  name            = "HealthProbe-001"
  loadbalancer_id = azurerm_lb.internal_lb.id
  protocol        = "Http"
  port            = 80
  request_path    = "/"
  interval_in_seconds = 15
}

resource "azurerm_lb_rule" "http_rule" {
  name                           = "HTTPRule-001"
  loadbalancer_id                = azurerm_lb.internal_lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "LoadBalancerFrontEnd"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.http_probe.id
  idle_timeout_in_minutes        = 15
  enable_tcp_reset               = false
}