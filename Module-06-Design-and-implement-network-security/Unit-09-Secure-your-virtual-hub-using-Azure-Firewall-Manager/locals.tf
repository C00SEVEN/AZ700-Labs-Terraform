locals {
  tags = {
    environment = "dev"
    project     = "az700-labs"
    managed_by  = "terraform"
  }

  locations = {
    sa = "South Africa North"
  }

  # Spoke VNets 
  spoke_vnets = {
    spoke_01 = {
      name          = "Spoke-01"
      address_space = "10.0.0.0/16"
      subnet_name   = "Workload-01-SN"
      subnet_prefix = "10.0.1.0/24"
    }
    spoke_02 = {
      name          = "Spoke-02"
      address_space = "10.1.0.0/16"
      subnet_name   = "Workload-02-SN"
      subnet_prefix = "10.1.1.0/24"
    }
  }
}
