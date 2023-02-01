<#########################################################################
# This script is intened to start tackling my domain config issues. I aim to auto-login the dc to finish configuring GPO stuff, 
#   which will hopefully allow the jumpbox to execute things successfully.
#
# I'll test this in my DomainConfig.ps1 then migrate everything to DC_Config.ps1 for naming consistency.
#
##########################################################################>

Write-Host "Starting Sleep for 60 seconds."
Start-Sleep -s 60

Start-Transcript -Path "C:\transcript.txt" -NoClobber

$name = "Script_VM"
$dcname = "10.0.1.10"

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
            Write-Host "Me thinks thy OU doth exist."
            $Error[0] = $null
            break
        }

    Write-Host "End of inital Try, total attempts: $($status)"
    Write-Host "Starting Sleep for 60 seconds to try again."
    Start-Sleep -s 60
    $status += 1
    }

  catch
  {
   Write-Host "Starting Sleep for 60 seconds and trying again."
   Start-Sleep -s 60
   Write-Host "End catch attempt: $($status)"
   $status += 1
  }
}

Stop-Transcript
