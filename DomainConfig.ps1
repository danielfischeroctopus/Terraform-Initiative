$user = "TFI\daniel"
$pass = "Passw0rd1"
$pass = ConvertTo-SecureString $pass -AsPlainText -Force

Add-WindowsFeature -name ad-domain-services -IncludeManagementTools
Install-ADDSForest -CreateDnsDelegation:$false -DomainMode 7 -DomainName "TFI.LOCAL" -ForestMode 7 -InstallDns:$true -SafeModeAdministratorPassword $pass -Force:$true
Start-Sleep -s 10
Start-Service -Name "Active Directory Domain Services"
Start-Sleep -s 10
New-AdOrganizationalUnit -Name "Domain Computers" -Path "DC=TFI,DC=LOCAL"  -ProtectedFromAccidentalDeletion $False
shutdown -r -t 10
