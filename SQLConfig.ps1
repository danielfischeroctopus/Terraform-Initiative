####################################################################################################
# SQL server configuration script.
# 
# Install Choco, SQL-Server-Express, SQL-Server-Management-Studio
# 
# 
# 
####################################################################################################
Write-Host "Starting Sleep for 60 seconds."
Start-Sleep -s 60

Start-Transcript -Path "C:\transcript.txt" -NoClobber

$name = "SQL"
$dcname = "10.0.1.10"

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
while ($status -lt 5 )
{
  try 
  {
    Invoke-Command -Authentication CredSSP -ScriptBlock {New-AdOrganizationalUnit -Name "Domain Computers" -Path "DC=TFI,DC=LOCAL" -ProtectedFromAccidentalDeletion $False} -ComputerName $dcname -Credential $credential -ErrorAction Continue
    
    if ($Error[0] -match "An attempt was made to add an object to the directory with a name that is already in use")
        {
            Write-Host "Error caught in the IF statement: $($Error[0])"
            $Error[0] = $null
            $status = 5
        }

    Write-Host "End of inital Try, total attempts: $($status)"
    Write-Host "Starting Sleep for 60 seconds to try again."
    Start-Sleep -s 60
    $status += 1
    }

  catch
  {
   Write-Host "Me thinks thy OU doth exist."
   Write-Host $_
   Write-Host "Starting Sleep for 60 seconds and trying again."
   Start-Sleep -s 60
   Write-Host "End catch attempt: $($status)"
   $status += 1
  }
}

Stop-Transcript
