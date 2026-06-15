variable "locations" {
  type = object({
    hub                 = string
    spoke_research      = string
    spoke_manufacturing = string
    erc                 = string
  })
  default = {
    hub                 = "eastus"
    spoke_research      = "southeastasia"
    spoke_manufacturing = "westeurope"
    erc                 = "eastus2"
  }
}