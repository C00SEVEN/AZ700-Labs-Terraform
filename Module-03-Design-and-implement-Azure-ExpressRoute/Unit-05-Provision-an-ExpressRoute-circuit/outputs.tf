output "service_key" {
  value = azurerm_express_route_circuit.TestERCircuit.service_key
  sensitive = true
}