# 1. Create NIC - Test VM on backend subnet
#    No public IP — access is via Bastion only
resource "azurerm_network_interface" "nic_vm" {
  name                = "nic-vm-sa-unit6-1"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet_backend.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.tags
}

# 2. Create Test VM 
resource "azurerm_windows_virtual_machine" "vm" {
  name                = "vm-sa-unit6-1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.locations.sa
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  admin_password      = var.vm_admin_password

  network_interface_ids = [
    azurerm_network_interface.nic_vm.id
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
