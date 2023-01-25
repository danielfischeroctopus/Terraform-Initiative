#####################################################################
# Start-Transcript records the PS session into text file. Makes it easier to read errors and catch some output that Azure may not.
# Declare user/pass for AD stuff
# WinRM config (This is to remote script stuff. I'm hoping that I can configure AD_OU and DNS(if needed) from a jumpbox or the SQL server.
#
#####################################################################
Start-Transcript -Path "C:\transcript.txt" -NoClobber

$user = "TFI\daniel"
$pass = "Passw0rd1"
$pass = ConvertTo-SecureString $pass -AsPlainText -Force

winrm quickconfig -quiet
Set-Item WSMan:\localhost\Client\TrustedHosts * -Force
winrm set winrm/config/service/Auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="1024"}'

Add-WindowsFeature -name ad-domain-services -IncludeManagementTools
Install-ADDSForest -CreateDnsDelegation:$false -DomainMode 7 -DomainName "TFI.LOCAL" -ForestMode 7 -InstallDns:$true -SafeModeAdministratorPassword $pass -NoRebootOnCompletion -Force:$true




Stop-Transcript

shutdown -r -t 10


#New-AdOrganizationalUnit -Name "Domain Computers" -Path "DC=TFI,DC=LOCAL" -ProtectedFromAccidentalDeletion $False
