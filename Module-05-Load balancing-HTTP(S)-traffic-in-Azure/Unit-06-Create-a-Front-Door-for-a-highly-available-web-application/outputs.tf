output "front_door_endpoint_fqdn" {
  value = azurerm_cdn_frontdoor_endpoint.fd_endpoint.host_name
}

output "primary_webapp_url" {
  value = azurerm_linux_web_app.ac_app1.default_hostname
}

output "failover_webapp_url" {
  value = azurerm_linux_web_app.ae_app1.default_hostname
}