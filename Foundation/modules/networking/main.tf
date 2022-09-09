resource "azurerm_virtual_network" "virtual_network" {
  name                = var.virNetName
  resource_group_name = var.rgName
  location            = var.location
  address_space       = ["10.0.0.0/16"]

  dns_servers = [
    "10.0.1.10",
    "8.8.8.8",
    "8.8.4.4"
  ]
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnetName
  resource_group_name  = var.rgName
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.1.0/24"]

}

resource "azurerm_network_security_group" "security_group" {
  name                = "network-security-group"
  location            = var.location
  resource_group_name = var.rgName

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.security_group.id
}