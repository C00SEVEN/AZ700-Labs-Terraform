output "application_gateway_fqdn" {
  value = azurerm_public_ip.pip_us_appgw.fqdn
}