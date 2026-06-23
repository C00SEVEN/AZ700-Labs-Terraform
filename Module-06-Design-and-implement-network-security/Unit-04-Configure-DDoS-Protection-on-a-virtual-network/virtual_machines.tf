#1. Create NIC
resource "azurerm_network_interface" "nic_vm" {
  name                = "nic-ddos-vm-001"
  location            = local.locations.us
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet_app.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_ddos.id
  }

  tags = local.tags
}

# 2. Create Linux VM 
resource "azurerm_linux_virtual_machine" "vm_ddos" {
  name                = "vm-az700-ddos-001"
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.locations.us
  size                = "Standard_D2s_v7"
  admin_username      = "azureuser"

  disable_password_authentication = false
  admin_password                  = var.vm_admin_password

  network_interface_ids = [
    azurerm_network_interface.nic_vm.id
  ]

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
}