# 1. Create Route Table 
resource "azurerm_route_table" "rt_fw" {
  name                          = "Firewall-route-sa-001"
  location                      = local.locations.sa
  resource_group_name           = azurerm_resource_group.rg.name
  bgp_route_propagation_enabled = true
  tags                          = local.tags
}

# 2. Create default rule (forced tunneling)
resource "azurerm_route" "route_fw_default" {
  name                   = "fw-forcedtunneling-001"
  resource_group_name    = azurerm_resource_group.rg.name
  route_table_name       = azurerm_route_table.rt_fw.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.fw.ip_configuration[0].private_ip_address
}

# 3. Create the Association to Workload subnet only
resource "azurerm_subnet_route_table_association" "rt_workload_assoc" {
  subnet_id      = azurerm_subnet.snet_workload.id
  route_table_id = azurerm_route_table.rt_fw.id
}