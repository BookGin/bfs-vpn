## Windows 10

1. Open Powershell as Administrator.
2. Run the following command:

     powershell -ExecutionPolicy ByPass -File windows-script-name.ps1 -Add

  The command has help information available. To view its full help, run this from Powershell:
    
     Get-Help -Name .\windows_USER.ps1 -Full | more

3. Start the VPN in your network settings.
4. Run the following command:
  
     route add 172.16.0.0 mask 255.255.0.0 10.10.10.123
