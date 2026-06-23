#1 Create Nics and Subnets
resource "azurerm_network_interface" "nic_backend" {
  count               = 2
  name                = "nic-us-vm${count.index + 1}"
  location            = local.locations.us
  resource_group_name = azurerm_resource_group.rg_us.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet_backend.id
    private_ip_address_allocation = "Dynamic"
  }
    tags = local.tags
}


#2 Create App Gw Public ip 
resource "azurerm_public_ip" "pip_us_appgw" {
  name                = "pip-us-appgw-001"
  location            = local.locations.us
  resource_group_name = azurerm_resource_group.rg_us.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "appgw001"
  tags                = local.tags
}

#3 Create linux Virtual Machines backend
resource "azurerm_linux_virtual_machine" "vm1_us" {
  count               = 2
  name                = "vm${count.index + 1}-backend-us-appgw"
  resource_group_name = azurerm_resource_group.rg_us.name
  location            = local.locations.us
  size                = "Standard_D2s_v7"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.nic_backend[count.index].id,
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

#3.1 Reads and references the standalone cloud-init.}yaml file directly
custom_data = base64encode(templatefile("${path.module}/cloud-init.yaml", {
  vm_name = "vm${count.index + 1}"
}))
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nic_appgw_assoc" {
  count = 2
  network_interface_id    = azurerm_network_interface.nic_backend[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = tolist(azurerm_application_gateway.app_gw_contoso.backend_address_pool)[0].id
}