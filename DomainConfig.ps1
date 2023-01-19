$user = "TFI\daniel"
$pass = "Passw0rd1"

$xml = @"
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.4" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Author>TFI\dadmin</Author>
    <URI>\NewOU</URI>
  </RegistrationInfo>
  <Triggers>
    <BootTrigger>
      <Enabled>false</Enabled>
      <Delay>PT1M</Delay>
    </BootTrigger>
    <EventTrigger>
      <Repetition>
        <Interval>PT1M</Interval>
        <Duration>PT2M</Duration>
        <StopAtDurationEnd>true</StopAtDurationEnd>
      </Repetition>
      <Enabled>true</Enabled>
      <Subscription>&lt;QueryList&gt;&lt;Query Id="0" Path="Directory Service"&gt;&lt;Select Path="Directory Service"&gt;*[System[Provider[@Name='Microsoft-Windows-ActiveDirectory_DomainService'] and EventID=1000]]&lt;/Select&gt;&lt;/Query&gt;&lt;/QueryList&gt;</Subscription>
      <Delay>PT1M</Delay>
    </EventTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <UserId>S-1-5-21-4067610301-2148880173-3558472291-500</UserId>
      <LogonType>Password</LogonType>
      <RunLevel>HighestAvailable</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>StopExisting</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>true</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>false</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <DisallowStartOnRemoteAppSession>false</DisallowStartOnRemoteAppSession>
    <UseUnifiedSchedulingEngine>true</UseUnifiedSchedulingEngine>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT1H</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe</Command>
      <Arguments>New-AdOrganizationalUnit -Name "AAA" -Path "DC=TFI,DC=LOCAL"  -ProtectedFromAccidentalDeletion $False</Arguments>
    </Exec>
  </Actions>
</Task>
"@

Register-ScheduledTask -TaskName "NewOU" -Xml $xml -Force -User $user -Password $pass

<#
New-AdOrganizationalUnit -Name "AAA" -Path "DC=TFI,DC=LOCAL"  -ProtectedFromAccidentalDeletion $False

$Sta = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-file C:\NewOU.ps1"
$Stt = New-ScheduledTaskTrigger -AtStartup
$Stprin = New-ScheduledTaskPrincipal -UserId $user -LogonType Password -RunLevel Highest
Register-ScheduledTask NewOU -Action $Sta -Trigger $Stt -Principal $Stprin -User "dadmin" -Password $pass


winrm quickconfig -quiet
Set-Item WSMan:\localhost\Client\TrustedHosts * -Force
#Install-Module PowerShellGet -AllowClobber -Force
#Install-PackageProvider NuGet -Force
winrm set winrm/config/service/Auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="1024"}'
#>

Import-Module ActiveDirectory -Force
#Set-ExecutionPolicy Bypass -Scope Process -Force
#Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
$pass = ConvertTo-SecureString $pass -AsPlainText -Force
Add-WindowsFeature -name ad-domain-services -IncludeManagementTools
Install-ADDSForest -CreateDnsDelegation:$false -DomainMode 7 -DomainName "TFI.LOCAL" -ForestMode 7 -InstallDns:$true -SafeModeAdministratorPassword $pass -Force:$true
shutdown -r -t 10
