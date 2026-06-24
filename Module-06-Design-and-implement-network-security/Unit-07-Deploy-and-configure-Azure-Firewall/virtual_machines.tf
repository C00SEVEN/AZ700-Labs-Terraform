# 1. Create NIC
resource "azurerm_network_interface" "nic_work" {
  name                = "nic-srv-work-001"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name
  dns_servers         = ["209.244.0.3", "209.244.0.4"]

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet_workload.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.tags
}

# 2. Create Workload VM
resource "azurerm_windows_virtual_machine" "vm_work" {
  name                = "Srv-Work-sa-001"
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.locations.sa
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  admin_password      = var.vm_admin_password

  network_interface_ids = [
    azurerm_network_interface.nic_work.id
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