# 1. Create NIC - Public subnet VM
resource "azurerm_network_interface" "nic_public" {
  name                = "nic-srv-public-001"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet_public.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_srv_public.id
  }

  tags = local.tags
}

# 2. create Public IP for the Public subnet VM 
resource "azurerm_public_ip" "pip_srv_public" {
  name                = "pip-srv-public-001"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

# 3. Create Workload VM for Public subnet
resource "azurerm_windows_virtual_machine" "vm_public" {
  name                = "vm-srvpu-sa-1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.locations.sa
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  admin_password      = var.vm_admin_password

  network_interface_ids = [
    azurerm_network_interface.nic_public.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  patch_mode = "AutomaticByPlatform"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2025-Datacenter-Azure-Edition"
    version   = "latest"
  }

  tags = local.tags
}

# 4. Create NIC - Private subnet VM
resource "azurerm_network_interface" "nic_private" {
  name                = "nic-srv-private-1"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet_private.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.tags
}

# 5. Create Workload VM - Private subnet, 
# No public IP — RDP tested via Public VM jumping internally, or Bastion in production
resource "azurerm_windows_virtual_machine" "vm_private" {
  name                = "vm-srvpv-sa-1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.locations.sa
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  admin_password      = var.vm_admin_password

  network_interface_ids = [
    azurerm_network_interface.nic_private.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  patch_mode = "AutomaticByPlatform"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2025-Datacenter-Azure-Edition"
    version   = "latest"
  }

  tags = local.tags
}