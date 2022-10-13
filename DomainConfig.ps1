$user = "TFI.LOCAL\daniel"
$pass = "Passw0rd1"

winrm quickconfig -quiet
Set-Item WSMan:\localhost\Client\TrustedHosts * -Force
#Install-Module PowerShellGet -AllowClobber -Force
#Install-PackageProvider NuGet -Force
Import-Module ActiveDirectory -Force
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
$pass = ConvertTo-SecureString $pass -AsPlainText -Force
Add-WindowsFeature -name ad-domain-services -IncludeManagementTools
Install-ADDSForest -CreateDnsDelegation:$false -DomainMode 7 -DomainName "TFI.LOCAL" -ForestMode 7 -InstallDns:$true -SafeModeAdministratorPassword $pass -Force:$true
shutdown -r -t 10
