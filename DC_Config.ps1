<#########################################################################
# This script is intened to start tackling my domain config issues. I aim to auto-login the dc to finish configuring GPO stuff, 
#   which will hopefully allow the jumpbox to execute things successfully.
#
# I'll test this in my DomainConfig.ps1 then migrate everything to DC_Config.ps1 for naming consistency.
#
##########################################################################>

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Value "TFI\Daniel"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value "Passw0rd1"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value "1"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name ForceAutoLogon -Value "1"
