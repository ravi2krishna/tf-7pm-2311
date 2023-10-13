# Virtual Network
resource "azurerm_virtual_network" "ecomm-vnet" {
  name                = "ecomm-network"
  location            = azurerm_resource_group.ecomm-rg.location
  resource_group_name = azurerm_resource_group.ecomm-rg.name
  address_space       = ["10.0.0.0/16"]
      tags = {
    env = "prod"
  }
}

# Web Subnet
resource "azurerm_subnet" "ecomm-web-sn" {
  name                 = "ecomm-web-subnet"
  resource_group_name  = azurerm_resource_group.ecomm-rg.name
  virtual_network_name = azurerm_virtual_network.ecomm-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Database Subnet
resource "azurerm_subnet" "ecomm-db-sn" {
  name                 = "ecomm-database-subnet"
  resource_group_name  = azurerm_resource_group.ecomm-rg.name
  virtual_network_name = azurerm_virtual_network.ecomm-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}