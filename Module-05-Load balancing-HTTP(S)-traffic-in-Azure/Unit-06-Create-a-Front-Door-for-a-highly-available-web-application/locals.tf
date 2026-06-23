locals {
  tags = {
    environment = "dev"
    project     = "az700-labs"
    managed_by  = "terraform"
  }

  locations = {
    ac = "Australia Central"
    ae = "Australia East"
  }
}