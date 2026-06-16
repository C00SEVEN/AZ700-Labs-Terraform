output "lb_private_ip" {
  value = azurerm_lb.internal_lb.frontend_ip_configuration[0].private_ip_address
}