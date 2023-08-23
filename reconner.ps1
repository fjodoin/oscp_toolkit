# Get current date and time for timestamping the output files
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
# Get the hostname and username
$hostname = $env:COMPUTERNAME
$username = $env:USERNAME
# Set the output directory and file name
$outputDir = "C:\Windows\Tasks"
$outputFile = Join-Path -Path $outputDir -ChildPath "$hostname`_$username`_reconner.txt"
# Create the output directory if it doesn't exist
if (-not (Test-Path -Path $outputDir)) {
 New-Item -ItemType Directory -Path $outputDir | Out-Null
}
# Define the commands to execute
$commands = @(
 "hostname",
 "whoami",
 "whoami /groups",
 "whoami /priv",
 "ipconfig /all",
 "netstat -ano",
 "route print",
 "systeminfo",
 "Get-ChildItem -Path 'C:\Users\' -Include *.git,*.exe,*.conf,*.config,*.ps1,*.php,*.aspx,*.kdbx,*.db,*.txt,*.pdf,*.xls,*.xlsx,*.doc,*.docx -File -Recurse -ErrorAction SilentlyContinue",
 "Get-ChildItem -Path 'C:\ProgramData\' -Include *.git,*.exe,*.conf,*.config,*.ps1,*.php,*.aspx,*.kdbx,*.db,*.txt,*.pdf,*.xls,*.xlsx,*.doc,*.docx -File -Recurse -ErrorAction SilentlyContinue",
 "Get-ChildItem -Path 'C:\Program Files\' -Include *.git,*.exe,*.conf,*.config,*.ps1,*.php,*.aspx,*.kdbx,*.db,*.txt,*.pdf,*.xls,*.xlsx,*.doc,*.docx -File -Recurse -ErrorAction SilentlyContinue",
 "arp -a",
 "net user $username",
 "net localgroup",
 "netsh advfirewall show allprofiles",
 "reg query 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall' /s | Select-String -Pattern 'DisplayName' -CaseSensitive",
 "reg query 'HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall' /s | Select-String -Pattern 'DisplayName' -CaseSensitive",
 "wevtutil qe ScriptBatch /q:*[System[(EventID=4104)]] /f:text",
 "Get-Content -Path $env:APPDATA\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt",
 "Get-CimInstance -ClassName Win32_Service -Property Name, DisplayName, PathName, StartMode, StartName | Select-Object PathName, StartName"
)
# Execute commands and append output to the reconner.txt file
foreach ($command in $commands) {
 Write-Host "Running: $command"
 Add-Content -Path $outputFile -Value "-------------------------------"
 Add-Content -Path $outputFile -Value "Output for: $command"
 Add-Content -Path $outputFile -Value "-------------------------------"
 Add-Content -Path $outputFile -Value ""
 try {
 $output = Invoke-Expression -Command $command
 Add-Content -Path $outputFile -Value $output
 }
 catch {
 $errorMessage = $_.Exception.Message
 Add-Content -Path $outputFile -Value "Error: $errorMessage"
 }
 Add-Content -Path $outputFile -Value ""
}
Write-Host "Reconner script completed. Output file saved at: $outputFile"
