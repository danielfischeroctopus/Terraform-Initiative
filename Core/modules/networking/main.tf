resource "azurerm_virtual_network" "virtual_network" {
  name                = var.virNetName
  address_space       = ["10.0.0.0/16"]
  resource_group_name = var.rgName
  location            = var.location
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnetName
  resource_group_name  = var.rgName
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.2.0/24"]
}
