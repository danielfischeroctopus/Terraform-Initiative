####################################################################################################
# TeamCity server configuration script.
# 
# Install Choco, TeamCity
# 
# 
# 
####################################################################################################


# Set Execution Policy
Set-ExecutionPolicy Bypass -Scope Process -Force

# Install Chocolaty
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Software
choco install teamcity
