# 1. Create Public IP
resource "azurerm_public_ip" "pip_fw" {
  name                = "fw-pip-testfw-sa-001"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

# 2. create Firewall Policy
resource "azurerm_firewall_policy" "fw_policy" {
  name                = "fw-pol-testfw-sa-001"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

# 3. Create Azure Firewall
resource "azurerm_firewall" "fw" {
  name                = "fw-test-sa-001"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.fw_policy.id
  tags                = local.tags

  ip_configuration {
    name                 = "fw-ip-config"
    subnet_id            = azurerm_subnet.snet_firewall.id
    public_ip_address_id = azurerm_public_ip.pip_fw.id
  }
}

# 4. create Application Rule — Allow Google
resource "azurerm_firewall_policy_rule_collection_group" "app_rules" {
  name               = "App-Coll01-Group"
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 200

  application_rule_collection {
    name     = "App-Coll001"
    priority = 200
    action   = "Allow"

    rule {
      name = "Allow-Google"
      source_addresses = ["10.0.2.0/24"]

      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }

      destination_fqdns = ["www.google.com"]
    }
  }
}

# 5. create Network Rule — Allow DNS
resource "azurerm_firewall_policy_rule_collection_group" "net_rules" {
  name               = "Net-Coll001-Group"
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 300

  network_rule_collection {
    name     = "Net-Coll001"
    priority = 200
    action   = "Allow"

    rule {
      name                  = "Allow-DNS"
      source_addresses      = ["10.0.2.0/24"]
      destination_addresses = ["209.244.0.3", "209.244.0.4"]
      destination_ports     = ["53"]
      protocols             = ["UDP"]
    }
  }
}

# 6. Create DNAT Rule — RDP
resource "azurerm_firewall_policy_rule_collection_group" "dnat_rules" {
  name               = "rdp-Group"
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 100

  nat_rule_collection {
    name     = "rdp"
    priority = 200
    action   = "Dnat"

    rule {
      name                = "rdp-dnat"
      source_addresses    = ["*"]
      destination_address = azurerm_public_ip.pip_fw.ip_address
      destination_ports   = ["3389"]
      protocols           = ["TCP"]
      translated_address  = azurerm_windows_virtual_machine.vm_work.private_ip_address
      translated_port     = "3389"
    }
  }
}