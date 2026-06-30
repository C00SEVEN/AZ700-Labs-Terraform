# 1. Create NICs 
resource "azurerm_network_interface" "nic_workload" {
  for_each = local.spoke_vnets

  name                = "nic-srv-${lower(each.value.name)}-001"
  location            = local.locations.sa
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.workload[each.key].id
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.tags
}

# 2. Create Workload VMs 
resource "azurerm_windows_virtual_machine" "vm_workload" {
  for_each = local.spoke_vnets

  name                = "Srv-workload-${trimprefix(each.value.name, "Spoke-")}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.locations.sa
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  admin_password      = var.vm_admin_password

  network_interface_ids = [
    azurerm_network_interface.nic_workload[each.key].id
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
