# 1. Create Storage Account
resource "azurerm_storage_account" "st_az700" {
  name                     = "az700labs001"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = local.locations.sa
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  tags                     = local.tags
}

# 2. Create File Share name "marketing"
resource "azurerm_storage_share" "share_marketing" {
  name               = "marketing"
  storage_account_name = azurerm_storage_account.st_az700.name
  quota              = 5
}

# 3. Create a Restriction on Storage Account network access — deny by default,
#    allow only the Private subnet via Service Endpoint
resource "azurerm_storage_account_network_rules" "st_contoso_rules" {
  storage_account_id = azurerm_storage_account.st_az700.id

  default_action = "Deny"
  bypass         = ["AzureServices"]

  virtual_network_subnet_ids = [
    azurerm_subnet.snet_private.id
  ]

  depends_on = [
    azurerm_subnet.snet_private,
     azurerm_storage_share.share_marketing
  ]
}