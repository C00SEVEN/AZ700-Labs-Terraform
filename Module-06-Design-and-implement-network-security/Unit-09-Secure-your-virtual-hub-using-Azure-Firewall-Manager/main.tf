# 1. Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "fw-manager-rg"
  location = local.locations.sa
  tags     = local.tags
}

#2. Create Spoke VNets
resource "azurerm_virtual_network" "spoke" {
  for_each = local.spoke_vnets

  name                = each.value.name
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [each.value.address_space]
  tags                = local.tags
}

# 3. Create Workload Subnets
resource "azurerm_subnet" "workload" {
  for_each = local.spoke_vnets

  name                 = each.value.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke[each.key].name
  address_prefixes     = [each.value.subnet_prefix]
}

# 4. Create  Virtual WAN 
resource "azurerm_virtual_wan" "vwan" {
  name                = "Vwan-01"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

#5. Create Secured Virtual Hub
resource "azurerm_virtual_hub" "hub" {
  name                = "Hub-01"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = "10.2.0.0/16"
  tags                = local.tags
}

# 6. Create Hub-to-Spoke connections
resource "azurerm_virtual_hub_connection" "spoke_connection" {
  for_each = local.spoke_vnets

  name                      = "hub-${lower(replace(each.value.name, "-", "-"))}"
  virtual_hub_id            = azurerm_virtual_hub.hub.id
  remote_virtual_network_id = azurerm_virtual_network.spoke[each.key].id
  internet_security_enabled  = true
}


#7. Create Routing using HUB(forcing internet traffic on through Firewall)
resource "azurerm_virtual_hub_routing_intent" "internet" {
  name           = "default_internet_route"
  virtual_hub_id = azurerm_virtual_hub.hub.id

  routing_policy {
    name         = "InternetTraffic"
    destinations = ["Internet"]
    next_hop     = azurerm_firewall.hub_fw.id
  }

  routing_policy {
    name         = "PrivateTraffic"
    destinations = ["PrivateTraffic"]
    next_hop     = azurerm_firewall.hub_fw.id
  }

  depends_on = [
    azurerm_firewall.hub_fw,
    azurerm_virtual_hub_connection.spoke_connection
  ]
}