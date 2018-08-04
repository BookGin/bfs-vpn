## Windows 10

1. Open Coomand Line/Powershell as Administrator.
2. Run the following command:

     powershell -ExecutionPolicy ByPass -File {{ windows10_config_filename }} -Add

  The command has help information available. To view its full help, run this from Powershell:
    
     Get-Help -Name .\{{ windows10_config_filename }} -Full | more

3. Start the VPN in your network settings.

## Windows 8

1. Open PowerShell as Administrator.
2. If you haven't already, you will need to change the Execution Policy to allow unsigned scripts to run.

     Set-ExecutionPolicy Unrestricted -Scope CurrentUser

3. Execute the script with powershell.

     powershell {{ windows8_config_filename }}

4. Set the Execution Policy back before you close the PowerShell window.
     
     Set-ExecutionPolicy Restricted -Scope CurrentUser

5. Your VPN is now installed and ready to use.
