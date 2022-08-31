# Set Execution Policy
Set-ExecutionPolicy Bypass -Scope Process -Force

# Install Chocolaty
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install notepadplusplus -y

# Configure server as both client and server to enable double hops (https://octopus.com/blog/azure-script-extension#supporting-powershell-double-hops)
Enable-WSManCredSSP -Role Server -Force
Enable-WSManCredSSP -Role Client -DelegateComputer * -Force

# Allow use of NTLM account since we're using local account and not domain.
New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation -Name AllowFreshCredentialsWhenNTLMOnly -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation\AllowFreshCredentialsWhenNTLMOnly -Name 1 -Value * -PropertyType String


# Run PowerShell script under a new user & Install SQL-Server-Express
# make var
$securePassword = ConvertTo-SecureString 'passwordgoeshere' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential 'hostname\testadmin', $securePassword
Invoke-Command -Authentication CredSSP -ScriptBlock {choco install sql-server-express -y} -ComputerName hostname -Credential $credential
