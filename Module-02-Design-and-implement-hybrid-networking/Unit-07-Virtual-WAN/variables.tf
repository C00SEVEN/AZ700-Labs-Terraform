variable "locations" {
  type = object({
    hub                 = string
    spoke_research      = string
    spoke_manufacturing = string
    vwan                = string
  })
  default = {
    hub                 = "eastus"
    spoke_research      = "southeastasia"
    spoke_manufacturing = "westeurope"
    vwan                = "westus"
  }
}
