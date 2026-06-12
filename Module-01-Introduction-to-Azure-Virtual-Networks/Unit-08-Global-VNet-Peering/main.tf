#1 Create tags
locals {
  tags = {
    environment = "dev"
    project     = "az700-labs"
    managed_by  = "terraform"
    topology    = "hub-and-spoke"
  }
}
#2. Create a Resource Group 
resource "azurerm_resource_group" "rg" {
  name     = "rg-contoso-connectivity-shared-eastus"
  location = var.locations.hub
  tags     = local.tags
}
  
#3. Create Hub vnet
resource "azurerm_virtual_network" "core_services_vnet" {
  name                = "vnet-hub-core-eastus"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.locations.hub
  address_space       = ["10.20.0.0/16"]
  tags                = local.tags
  }

#3.1 Create Hub subnets
resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet" 
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.core_services_vnet.name
  address_prefixes     = ["10.20.0.0/27"]
}

resource "azurerm_subnet" "shared_services" {
  name                 = "snet-hub-sharedservices-001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.core_services_vnet.name
  address_prefixes     = ["10.20.10.0/24"]
}

resource "azurerm_subnet" "database" {
  name                 = "snet-hub-database-001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.core_services_vnet.name
  address_prefixes     = ["10.20.20.0/24"]
}

resource "azurerm_subnet" "public_web" {
  name                 = "snet-hub-publicweb-001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.core_services_vnet.name
  address_prefixes     = ["10.20.30.0/24"]
}

#4. Create Manufacturing vnet 
resource "azurerm_virtual_network" "manufacturing_vnet" {
  name                = "vnet-spoke-manufacturing-westeurope"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.locations.spoke_manufacturing
  address_space       = ["10.30.0.0/16"]
  tags = local.tags
}

#4.1 Create Manufacturing Subnets 
resource "azurerm_subnet" "manufacturing_system" {
  name                 = "snet-mfg-system-001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.manufacturing_vnet.name
  address_prefixes     = ["10.30.10.0/24"]
}

resource "azurerm_subnet" "sensor_1" {
  name                 = "snet-mfg-sensor-001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.manufacturing_vnet.name
  address_prefixes     = ["10.30.20.0/24"]
}

resource "azurerm_subnet" "sensor_2" {
  name                 = "snet-mfg-sensor-002"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.manufacturing_vnet.name
  address_prefixes     = ["10.30.21.0/24"]
}

resource "azurerm_subnet" "sensor_3" {
  name                 = "snet-mfg-sensor-003"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.manufacturing_vnet.name
  address_prefixes     = ["10.30.22.0/24"]
}

#5. Create Research vnet 
resource "azurerm_virtual_network" "research_vnet" {
  name                = "vnet-spoke-research-southeastasia"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.locations.spoke_research
  address_space       = ["10.40.0.0/16"]
  tags = local.tags
}
#5.1 Create Research subnets 
resource "azurerm_subnet" "research_system" {
  name                 = "snet-research-system-001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.research_vnet.name
  address_prefixes     = ["10.40.0.0/24"]
}

#6 Create Private Dns Zone
resource "azurerm_private_dns_zone" "private_dns" {
  name                = var.private_dns_zone_name
  resource_group_name = azurerm_resource_group.rg.name
}
#6.1 Link Private Dns Zone to Vnet
resource "azurerm_private_dns_zone_virtual_network_link" "hub_dns_link" {
  name                  = "CoreServicesVnetLink"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns.name
  virtual_network_id    = azurerm_virtual_network.core_services_vnet.id
  registration_enabled = true
}
#7 Create Public ip
resource "azurerm_public_ip" "vm1_pip" {
  name                = "vm1-pip"
  location            = var.locations.hub
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}
resource "azurerm_public_ip" "vm2_pip" {
  name                = "vm2-pip"
  location            = var.locations.spoke_manufacturing
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}
#8 create Nics
resource "azurerm_network_interface" "vm1_nic" {
  name                = "vm1-nic"
  location            = var.locations.hub
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.database.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id         = azurerm_public_ip.vm1_pip.id
  }
    tags                = local.tags
}
resource "azurerm_network_interface" "vm2_nic" {
  name                = "vm2-nic"
  location            = var.locations.spoke_manufacturing
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.manufacturing_system.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id         = azurerm_public_ip.vm2_pip.id
  }
    tags                = local.tags
}
#9 create Vms
resource "azurerm_windows_virtual_machine" "vm1" {
  name                = "testvm1-Core-01"
  location            = var.locations.hub
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_D2ls_v7"

  admin_username                  = "azureuser"
  admin_password                  = var.vm_admin_password

  network_interface_ids = [
    azurerm_network_interface.vm1_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  patch_mode = "AutomaticByPlatform"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2025-datacenter-azure-edition"
    version   = "latest"
  }
  tags = local.tags
}

resource "azurerm_windows_virtual_machine" "vm2" {
  name                = "mfgVM-mfg-01"
  location            = var.locations.spoke_manufacturing
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_D2als_v6"

  admin_username                  = "azureuser"
  admin_password                  = var.vm_admin_password

  network_interface_ids = [
    azurerm_network_interface.vm2_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  patch_mode = "AutomaticByPlatform"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2025-datacenter-azure-edition"
    version   = "latest"
  }
  tags = local.tags
}

#10 Create NSG
resource "azurerm_network_security_group" "db_nsg" {
  name                = "nsg-database"
  location            = var.locations.hub
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow_RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.tags
}
resource "azurerm_network_security_group" "mfg_nsg" {
  name                = "nsg-Manufacturing"
  location            = var.locations.spoke_manufacturing
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow_RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.tags
}
resource "azurerm_subnet_network_security_group_association" "db_nsg_assoc" {
  subnet_id                 = azurerm_subnet.database.id
  network_security_group_id = azurerm_network_security_group.db_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "mfg_nsg_assoc" {
  subnet_id                 = azurerm_subnet.manufacturing_system.id
  network_security_group_id = azurerm_network_security_group.mfg_nsg.id
}

resource "azurerm_virtual_network_peering" "core_peering_mfg" {
  name                      = "CoreServicesVnet-to-ManufacturingVnet"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.core_services_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.manufacturing_vnet.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "mfg_peering_core" {
  name                      = "ManufacturingVnet-to-CoreServicesVnet"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.manufacturing_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.core_services_vnet.id
  allow_virtual_network_access = true
}

