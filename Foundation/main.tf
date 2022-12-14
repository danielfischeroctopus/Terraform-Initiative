# Locals for DC promotion script.
locals {
  winrm_command        = "winrm quickconfig -quiet"
  import_command       = "Import-Module ADDSDeployment"
  password_command     = "$password = ConvertTo-SecureString ${var.domainPass} -AsPlainText -Force"
  install_ad_command   = "Add-WindowsFeature -name ad-domain-services -IncludeManagementTools"
  configure_ad_command = "Install-ADDSForest -CreateDnsDelegation:$false -DomainMode 7 -DomainName ${var.domain} -ForestMode 7 -InstallDns:$true -SafeModeAdministratorPassword $password -Force:$true"
  shutdown_command     = "shutdown -r -t 10"
  exit_code_hack       = "exit 0"
  powershell_command   = "${local.winrm_command}; ${local.import_command}; ${local.password_command}; ${local.install_ad_command}; ${local.configure_ad_command}; ${local.shutdown_command}; ${local.exit_code_hack}"
}

# Resources and Providers
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.rgName
  location = var.location
}

# Networking module. Setting rgName to var.rgName is passing the core module's default to the empty var in the module.
module "networking" {
  source = ".\\modules\\networking"

  rgName     = var.rgName
  location   = var.location
  virNetName = var.virNetName
  subnetName = var.subnetName

  depends_on = [azurerm_resource_group.rg]
}

# VM Modules & config
module "DC_vm" {
  source = ".\\modules\\vm"

  vmName     = "DC"
  subnetId   = module.networking.subnet_id
  rgName     = var.rgName
  location   = var.location
  localUser  = var.localUser
  localPass  = var.localPass
  domainUser = var.domainUser
  domainPass = var.domainPass
  staticIP   = "10.0.1.10"

  depends_on = [
    azurerm_resource_group.rg,
    module.networking
  ]
}

module "DC_extension" {
  source = ".\\modules\\extension"

  extName     = "DC"
  rgName      = var.rgName
  location    = var.location
  vmId        = module.DC_vm.vmId
  extSettings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe -Command \"${local.powershell_command}\""
    }
SETTINGS
  depends_on = [
    module.DC_vm
  ]
}

module "SQL_vm" {
  source = ".\\modules\\vm"

  vmName     = "SQL"
  subnetId   = module.networking.subnet_id
  rgName     = var.rgName
  location   = var.location
  localUser  = var.localUser
  localPass  = var.localPass
  domainUser = var.domainUser
  domainPass = var.domainPass
  staticIP   = "10.0.1.20"

  depends_on = [azurerm_resource_group.rg]
}

module "SQL_domainJoin_extension" {
  source = ".\\modules\\domainJoin"

  extName    = "SQL_DomainJoin"
  rgName     = var.rgName
  location   = var.location
  vmId       = module.SQL_vm.vmId
  domain     = var.domain
  domainUser = var.domainUser
  domainPass = var.domainPass

  depends_on = [
    module.DC_extension,
    module.SQL_vm
  ]
}

module "SQL_extension" {
  source = ".\\modules\\extension"

  extName     = "SQL_Config"
  rgName      = var.rgName
  location    = var.location
  vmId        = module.SQL_vm.vmId
  extSettings = var.extSQL

  depends_on = [
    module.SQL_domainJoin_extension
  ]
} 
