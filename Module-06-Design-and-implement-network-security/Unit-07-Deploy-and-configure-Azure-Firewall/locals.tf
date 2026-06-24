locals {
  tags = {
    environment = "dev"
    project     = "az700-labs"
    managed_by  = "terraform"
  }

  locations = {
    sa = "South Africa North"
  }
}