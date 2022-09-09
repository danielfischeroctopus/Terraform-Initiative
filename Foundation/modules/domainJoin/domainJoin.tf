# extension
resource "azurerm_virtual_machine_extension" "extension" {
  name                 = var.extName
  virtual_machine_id   = var.vmId
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = 1.3

  settings           = <<SETTINGS
    {
        "Name": "${var.domain}",
        "OUPath": "OU=Servers,DC=TFI,DC=LOCAL",
        "User": "${var.domain}\\${var.domainUser}",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
    {
      "Password": "${var.domainPass}"
    }
  PROTECTED_SETTINGS
}