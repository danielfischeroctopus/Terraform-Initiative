####################################################################################################
# SQL server configuration script.
# 
# Install Choco, SQL-Server-Express, SQL-Server-Management-Studio
# 
# 
# 
####################################################################################################
Start-Transcript -Path "C:\transcript.txt" -NoClobber
# Set Execution Policy
Set-ExecutionPolicy Bypass -Scope Process -Force

# Parameters
$name = "SQL"
$dcname = "10.0.1.10"

Write-Host "Testing pings"
Write-Host "pinging IP"
ping 10.0.1.10
Write-Host "pinging Hostname"
ping DC.TFI.LOCAL

# Install Chocolaty
#Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Configure server as both client and server to enable double hops (https://octopus.com/blog/azure-script-extension#supporting-powershell-double-hops)
Enable-WSManCredSSP -Role Server -Force
Enable-WSManCredSSP -Role Client -DelegateComputer * -Force

# Allow use of NTLM account since we're using local account and not domain.
New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation -Name AllowFreshCredentialsWhenNTLMOnly -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation\AllowFreshCredentialsWhenNTLMOnly -Name 1 -Value * -PropertyType String


# Run PowerShell script under a new user & Install SQL-Server-Express
$securePassword = ConvertTo-SecureString 'Passw0rd1' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential 'TFI.LOCAL\daniel', $securePassword

$status = 0
while ($error -ne 5 ) {
  try {
  Invoke-Command -Authentication CredSSP -ScriptBlock {New-AdOrganizationalUnit -Name "Domain Computers" -Path "DC=TFI,DC=LOCAL" -ProtectedFromAccidentalDeletion $False} -ComputerName $dcname -Credential $credential
  $status = 5
  }
  catch {
   Start-Sleep -s 60
   $status + 1
   }
}
#Invoke-Command -Authentication CredSSP -ScriptBlock {New-AdOrganizationalUnit -Name "Domain Computers" -Path "DC=TFI,DC=LOCAL" -ProtectedFromAccidentalDeletion $False} -ComputerName $dcname -Credential $credential

#Invoke-Command -Authentication CredSSP -ScriptBlock {choco install sql-server-express -y} -ComputerName $name -Credential $credential
#Invoke-Command -Authentication CredSSP -ScriptBlock {choco install sql-server-management-studio -y} -ComputerName $name -Credential $credential

Stop-Transcript
