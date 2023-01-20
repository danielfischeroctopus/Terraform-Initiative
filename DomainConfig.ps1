$user = "TFI\daniel"
$pass = "Passw0rd1"
$pass = ConvertTo-SecureString $pass -AsPlainText -Force

#Add-WindowsFeature -name ad-domain-services -IncludeManagementTools
#Install-ADDSForest -CreateDnsDelegation:$false -DomainMode 7 -DomainName "TFI.LOCAL" -ForestMode 7 -InstallDns:$true -SafeModeAdministratorPassword $pass -NoRebootOnCompletion -Force:$true

Start-Transcript -Path "C:\transcripts\transcript0.txt" -NoClobber

Start-Sleep -s 10
Start-Service -DisplayName "Active Directory Web Services"
Start-Sleep -s 5
Start-Service -DisplayName "Active Directory Domain Services"
Start-Sleep -s 10 # Gives time for the ADWS service to boot and accept the next command.
New-AdOrganizationalUnit -Name "Domain Computers" -Path "DC=TFI,DC=LOCAL" -ProtectedFromAccidentalDeletion $False

Stop-Transcript

shutdown -r -t 10
