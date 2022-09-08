$dc = 'TFI.LOCAL'
$pw = 'Passw0rd1' | ConvertTo-SecureString -asPlainText –Force
$usr = 'TFI.LOCAL\daniel'
$creds = New-Object System.Management.Automation.PSCredential($usr,$pw)
Add-Computer -DomainName $dc -Credential $creds -restart -force -verbose
