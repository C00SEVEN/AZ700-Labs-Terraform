variable "locations" {
  type = object({
    hub                 = string
    spoke_research      = string
    spoke_manufacturing = string
  })
  default = {
    hub                 = "eastus"
    spoke_research      = "southeastasia"
    spoke_manufacturing = "westeurope"
  }
}

variable "vm_admin_password" {
  type        = string
  sensitive   = true
}