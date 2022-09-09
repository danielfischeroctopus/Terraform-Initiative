# extension
resource "azurerm_virtual_machine_extension" "extension" {
  name                 = var.extName
  virtual_machine_id   = var.vmId
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = 1.10

  settings = var.extSettings
}