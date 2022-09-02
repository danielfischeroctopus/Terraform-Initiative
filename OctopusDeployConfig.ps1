####################################################################################################
# Octopus Deploy server configuration script.
# 
# Install Choco, Octopus Server
# 
# 
# 
####################################################################################################

# Set Execution Policy
Set-ExecutionPolicy Bypass -Scope Process -Force

$name = "OD"

# Install Chocolaty
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Configure server as both client and server to enable double hops (https://octopus.com/blog/azure-script-extension#supporting-powershell-double-hops)
Enable-WSManCredSSP -Role Server -Force
Enable-WSManCredSSP -Role Client -DelegateComputer * -Force

# Allow use of NTLM account since we're using local account and not domain.
New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation -Name AllowFreshCredentialsWhenNTLMOnly -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation\AllowFreshCredentialsWhenNTLMOnly -Name 1 -Value * -PropertyType String


# Run PowerShell script under a new user & Install Octopus Deploy
# make var
$securePassword = ConvertTo-SecureString 'Passw0rd1' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential '$name\daniel', $securePassword
Invoke-Command -Authentication CredSSP -ScriptBlock {choco install octopusdeploy -y} -ComputerName $name -Credential $credential





