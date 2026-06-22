#1 Create Nics and Subnets
resource "azurerm_network_interface" "nic_us_vm1" {
  name                = "nic-us-vm1"
  location            = local.locations.us
  resource_group_name = azurerm_resource_group.rg_us.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet_us_app.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip_us_vm1.id
  }
    tags = local.tags
}

resource "azurerm_network_interface" "nic_eu_vm1" {
  name                = "nic-eu-vm1"
  location            = local.locations.eu
  resource_group_name = azurerm_resource_group.rg_eu.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet_eu_app.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip_eu_vm1.id
  }
    tags = local.tags
}

#2 Create Public ip
resource "azurerm_public_ip" "pip_us_vm1" {
  name                = "pip-us-vm1"
  location            = local.locations.us
  resource_group_name = azurerm_resource_group.rg_us.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "appus001"
  tags                = local.tags
}
resource "azurerm_public_ip" "pip_eu_vm1" {
  name                = "pip-eu-vm1"
  location            = local.locations.eu
  resource_group_name = azurerm_resource_group.rg_eu.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "appeu001"
  tags                = local.tags
}

#3 Create linux Virtual Machines
resource "azurerm_linux_virtual_machine" "vm1_us" {
  name                = "vm-app-us-001"
  resource_group_name = azurerm_resource_group.rg_us.name
  location            = local.locations.us
  size                = "Standard_D2s_v7"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.nic_us_vm1.id,
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
  vm_name = "vm1_us"
}))
}
resource "azurerm_linux_virtual_machine" "vm1_eu" {
  name                = "vm-app-eu-001"
  resource_group_name = azurerm_resource_group.rg_eu.name
  location            = local.locations.eu
  size                = "Standard_D2als_v6"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.nic_eu_vm1.id,
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

  #3.2 Reads and references the standalone cloud-init.yaml file directly
custom_data = base64encode(templatefile("${path.module}/cloud-init.yaml", {
  vm_name = "vm1_eu"
}))
}
