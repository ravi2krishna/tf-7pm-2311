# Resource Group
resource "azurerm_resource_group" "ecomm-rg" {
  name     = "ecomm-resources"
  location = "East US"
    tags = {
    env = "prod"
  }
}