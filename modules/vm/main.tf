# azure windows vm
resource "azurerm_windows_virtual_machine" "vm" {
  name                       = var.vmName
  resource_group_name        = var.rgName
  location                   = var.location
  admin_username             = var.localUser
  admin_password             = var.localPass
  size                       = "Standard_F4"
  allow_extension_operations = true
  network_interface_ids      = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

# nic & public ip
resource "azurerm_public_ip" "public_ip" {
  name                    = "${var.vmName}_public_ip"
  location                = var.location
  resource_group_name     = var.rgName
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.vmName}_nic"
  location            = var.location
  resource_group_name = var.rgName

  ip_configuration {
    name                          = "ip_configuration1"
    subnet_id                     = var.subnetId
    private_ip_address_allocation = "Static"
    private_ip_address            = var.staticIP
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

}

