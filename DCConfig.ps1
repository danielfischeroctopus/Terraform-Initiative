Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

/*
winrm quickconfig -quiet
Import-Module ADDSDeployment
Import-Module ActiveDirectory
$password = ConvertTo-SecureString Passw0rd1 -AsPlainText -Force
Add-WindowsFeature -name ad-domain-services -IncludeManagementTools
Install-ADDSForest -CreateDnsDelegation:$false -DomainMode 7 -DomainName "TFI.LOCAL" -ForestMode 7 -InstallDns:$true -SafeModeAdministratorPassword $password -Force:$true
shutdown -r -t 10
exit 0
*/

/*
New-SelfSignedCertificate -Subject 'CN=DC.TFI.LOCAL' -TextExtension '2.5.29.37={text}1.3.6.1.5.5.7.3.1'
$thumbprint = (Get-ChildItem -Path 'Cert:LocalMachine\MY' | Where-Object {$_.Subject -Match 'CN=DC.TFI.LOCAL'}).Thumbprint

winrm create winrm/config/Listener?Address=*+Transport=HTTPS '@{Hostname=${DC.TFI.LOCAL}; CertificateThumbprint=$thumpprint}'

$FirewallParam = @{
    DisplayName = 'Windows Remote Management (HTTPS-In)'
    Direction = 'Inbound'
    LocalPort = 5986
    Protocol = 'TCP'
    Action = 'Allow'
    Program = 'System'
}
New-NetFirewallRule @FirewallParam
*/
