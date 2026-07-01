#1 Create Nics
resource "azurerm_network_interface" "backend_nics" {
  count               = 3
  name                = "nic-myVM${count.index + 1}"
  location            = var.locations.hub
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.backend_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
    tags = local.tags
}

#2 Backend Pool Mapping
resource "azurerm_network_interface_backend_address_pool_association" "lb_assoc" {
  count                   = 3
  network_interface_id    = azurerm_network_interface.backend_nics[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
  depends_on = [azurerm_lb_backend_address_pool.backend_pool]
}

#3 Create 3 standalone Virtual Machines
resource "azurerm_linux_virtual_machine" "backend_vms" {
  count               = 3
  name                = "backendlb-eastus-VM${count.index + 1}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.locations.hub
  size                = "Standard_D2s_v7"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.backend_nics[count.index].id,
  ]

  disable_password_authentication = false
  admin_password                  = var.vm_admin_password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
 tags = local.tags

  #3.1 Reads and references the standalone cloud-init.yaml file directly
custom_data = base64encode(templatefile("${path.module}/cloud-init.yaml", {
  vm_name = "myVM${count.index + 1}"
}))

}
#4 Create Test VM
resource "azurerm_network_interface" "test_nic" {
  name                = "nic-myTestVM"
  location            = var.locations.hub
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.backend_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "test_vm" {
  name                = "testvm-001"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.locations.hub
  size                = "Standard_D2s_v7"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.test_nic.id,
  ]
  admin_password                  = var.vm_admin_password
  patch_mode = "AutomaticByPlatform"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

    source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2025-datacenter-azure-edition-smalldisk"
    version   = "latest"
  }
   tags = local.tags
}