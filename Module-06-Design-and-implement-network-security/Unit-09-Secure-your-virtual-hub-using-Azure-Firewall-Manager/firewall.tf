# 1. create Azure Firewall 
resource "azurerm_firewall" "hub_fw" {
  name                = "fw-hub-01-sa-001"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "AZFW_Hub"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.policy_01.id
  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.hub.id
    public_ip_count = 1
  }
  tags = local.tags
}

# 2.Creates Firewall Policy 
resource "azurerm_firewall_policy" "policy_01" {
  name                = "Policy-01"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  tags                = local.tags
}

# 3.Create Application Rule
resource "azurerm_firewall_policy_rule_collection_group" "app_rules" {
  name               = "App-RC-01"
  firewall_policy_id = azurerm_firewall_policy.policy_01.id
  priority           = 300 # higher number = lower priority — runs after DNAT

  application_rule_collection {
    name     = "App-RC-01"
    priority = 100
    action   = "Allow"

    rule {
      name             = "Allow-msft"
      source_addresses = ["*"]
      destination_fqdns = ["*.microsoft.com"]

      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
    }
  }
}

# 4. Creates DNAT Rule 
resource "azurerm_firewall_policy_rule_collection_group" "dnat_rules" {
  name               = "dnat-rdp-group"
  firewall_policy_id = azurerm_firewall_policy.policy_01.id
  priority           = 100 
  nat_rule_collection {
    name     = "dnat-rdp"
    priority = 100
    action   = "Dnat"

    rule {
      name                = "Allow-rdp-workload-01"
      source_addresses    = ["*"]
      destination_address = tolist(azurerm_firewall.hub_fw.virtual_hub[0].public_ip_addresses)[0]
      destination_ports   = ["3389"]
      protocols           = ["TCP"]
      translated_address  = azurerm_windows_virtual_machine.vm_workload["spoke_01"].private_ip_address
      translated_port     = "3389"
    }
  }
}

#5.Create Network Rule 
resource "azurerm_firewall_policy_rule_collection_group" "net_rules" {
  name               = "vnet-rdp-group"
  firewall_policy_id = azurerm_firewall_policy.policy_01.id
  priority           = 200

  network_rule_collection {
    name     = "vnet-rdp"
    priority = 100
    action   = "Allow"

    rule {
      name                  = "Allow-vnet-rdp"
      source_addresses      = ["*"]
      destination_addresses = [azurerm_windows_virtual_machine.vm_workload["spoke_02"].private_ip_address]
      destination_ports     = ["3389"]
      protocols             = ["TCP"]
    }
  }
}