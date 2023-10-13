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

# Web Network Security Group
resource "azurerm_network_security_group" "ecomm-web-nsg" {
  name                = "ecomm-web-firewall"
  location            = azurerm_resource_group.ecomm-rg.location
  resource_group_name = azurerm_resource_group.ecomm-rg.name

  security_rule {
    name                       = "ssh"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "http"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    env = "prod"
  }
}

# Database Network Security Group
resource "azurerm_network_security_group" "ecomm-db-nsg" {
  name                = "ecomm-database-firewall"
  location            = azurerm_resource_group.ecomm-rg.location
  resource_group_name = azurerm_resource_group.ecomm-rg.name

  security_rule {
    name                       = "ssh"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.0.0/16"
  }

    security_rule {
    name                       = "mysql"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.0.0/16"
  }

  tags = {
    env = "prod"
  }
}

# Associate Web Subnet - Web NSG
resource "azurerm_subnet_network_security_group_association" "ecomm-web-asc" {
  subnet_id                 = azurerm_subnet.ecomm-web-sn.id
  network_security_group_id = azurerm_network_security_group.ecomm-web-nsg.id
}

