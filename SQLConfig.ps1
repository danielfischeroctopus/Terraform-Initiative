####################################################################################################
# SQL server configuration script.
# 
# Install Choco, SQL-Server-Express, SQL-Server-Management-Studio
# 
# 
# 
####################################################################################################

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
$securePassword = ConvertTo-SecureString 'Passw0rd1' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential 'azure-vm\daniel', $securePassword
Invoke-Command -Authentication CredSSP -ScriptBlock {choco install sql-server-express -y} -ComputerName azure-vm -Credential $credential

# Install Software
choco install sql-server-management-studio

