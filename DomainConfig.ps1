$user = "TFI\daniel"
$pass = "Passw0rd1"

#Register-ScheduledTask -TaskName "NewOU" -Xml $xml -Force# -User $user -Password $pass

<#
New-AdOrganizationalUnit -Name "AAA" -Path "DC=TFI,DC=LOCAL"  -ProtectedFromAccidentalDeletion $False

$Sta = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-file C:\NewOU.ps1"
$Stt = New-ScheduledTaskTrigger -AtStartup
$Stprin = New-ScheduledTaskPrincipal -UserId $user -LogonType Password -RunLevel Highest
Register-ScheduledTask NewOU -Action $Sta -Trigger $Stt -Principal $Stprin -User "dadmin" -Password $pass


winrm quickconfig -quiet
Set-Item WSMan:\localhost\Client\TrustedHosts * -Force
#Install-Module PowerShellGet -AllowClobber -Force
#Install-PackageProvider NuGet -Force
winrm set winrm/config/service/Auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="1024"}'
#>

Import-Module ActiveDirectory -Force
#Set-ExecutionPolicy Bypass -Scope Process -Force
#Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
$pass = ConvertTo-SecureString $pass -AsPlainText -Force
Add-WindowsFeature -name ad-domain-services -IncludeManagementTools
Install-ADDSForest -CreateDnsDelegation:$false -DomainMode 7 -DomainName "TFI.LOCAL" -ForestMode 7 -InstallDns:$true -SafeModeAdministratorPassword $pass -Force:$true
Start-Service -Name "Active Directory Domain Services"
Start-Sleep -s 30
New-AdOrganizationalUnit -Name "Domain Computers" -Path "DC=TFI,DC=LOCAL"  -ProtectedFromAccidentalDeletion $False
#shutdown -r -t 10
