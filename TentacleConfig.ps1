####################################################################################################
# Octopus Tentacle server configuration script.
# 
# Install Choco, Octopus Tentacle
# 
# 
# 
####################################################################################################


# Set Execution Policy
Set-ExecutionPolicy Bypass -Scope Process -Force

# Install Chocolaty
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install octopusdeploy.tentacle
