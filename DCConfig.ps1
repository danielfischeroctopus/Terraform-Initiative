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
