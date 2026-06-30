# Show Public IP of Srv-Public
output "srv_public_ip" {
  description = "Public IP of Srv-Public-sa-001 — used to RDP in and jump to Srv-Private"
  value       = azurerm_public_ip.pip_srv_public.ip_address
}
# Show Private IPs of both VMs
output "vm_private_ips" {
  description = "Private IPs of workload VMs"
  value = {
    srv_public  = azurerm_network_interface.nic_public.private_ip_address
    srv_private = azurerm_network_interface.nic_private.private_ip_address
  }
}

# Show Storage account name
output "storage_account_name" {
  description = "Name of the storage account restricted to the Private subnet"
  value       = azurerm_storage_account.st_az700.name
}

#Show Storage account primary access key — sensitive, used to mount the file share
output "storage_account_primary_key" {
  description = "Primary access key for the storage account"
  value       = azurerm_storage_account.st_az700.primary_access_key
  sensitive   = true
}