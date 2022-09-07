variable "rgName" {
  default = "Terraform-Initiative"
}
variable "location" {
  default = "Australia East"
}

variable "localUser" {
  default = "daniel"
}

variable "localPass" {
  default = "Passw0rd1"
}

variable "domainUser" {
  default = "DCOCTO.LOCAL\\daniel"
}

variable "domainPass" {
  default = "Passw0rd1"
}

variable "active_directory_domain" {
  default = "TFI.LOCAL"
}

## DC/AD Variables

variable "hostname" {
  default = "DC.TFI.LOCAL"
}

## network module

variable "subnetName" {
  default = "subnet"
}

variable "virNetName" {
  default = "virtualNetwork"
}

variable "extSQL" {
  default = <<PROTECTED_SETTINGS
    {
      "fileUris": ["https://raw.githubusercontent.com/danielfischeroctopus/Terraform-Initiative/main/SQLConfig.ps1"],
      "commandToExecute": "powershell -file \"./SQLConfig.ps1\"" 
    }
  PROTECTED_SETTINGS
}

/* 
    extension = <<SETTINGS
    {
        "fileUris": ["C:\\My Drive\\VS Code\\Terraform Initiative\\Terraform-Project\\Scripts\\bginfo.ps1"],
        "commandToExecute": "powershell.exe -File \"./bginfo.ps1\"",
        "commandToExecute": "powershell.exe -Command \"${local.powershell_command}\""
    }
SETTINGS */
