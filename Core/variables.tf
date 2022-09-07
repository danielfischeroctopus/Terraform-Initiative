# Set some variable defaults for common values.
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

# Network module
variable "subnetName" {
  default = "subnet"
}

variable "virNetName" {
  default = "virtualNetwork"
}

# extensions
variable "extSQL" {
  default = <<PROTECTED_SETTINGS
    {
      "fileUris": ["https://raw.githubusercontent.com/danielfischeroctopus/Terraform-Initiative/main/SQLConfig.ps1"],
      "commandToExecute": "powershell -file \"./SQLConfig.ps1\"" 
    }
  PROTECTED_SETTINGS
}
