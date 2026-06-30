output "hub_firewall_public_ip" {
  description = "Public IP of the secured hub firewall — use this for DNAT/RDP rules"
  value       = tolist(azurerm_firewall.hub_fw.virtual_hub[0].public_ip_addresses)[0]
}
output "vm_private_ips" {
  description = "Private IPs of workload VMs — map by spoke key"
  value = {
    for k, vm in azurerm_windows_virtual_machine.vm_workload :
    k => vm.private_ip_address
  }
}
output "virtual_hub_id" {
  description = "Resource ID of the secured virtual hub"
  value       = azurerm_virtual_hub.hub.id
}
