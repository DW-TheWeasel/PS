<#
Using this file for useful PS snippets

To do:
Check PS logging
Make recommendations
Check reg for mshta, ps entries
Check reg for startup items
Check reg for bogus extension handlers?
#>

Clear-Host # Start with blank host

# Check PS version
Write-Host ("You are running Powershell version " + $PSVersionTable.PSVersion.Major)
Write-Host ($PSVersionTable | Out-String)


# Find all powershell processes and show command line used to launch
foreach($process in (Get-CimInstance Win32_Process -Filter "name = 'powershell.exe'")) {($process.Name + " (PID:" + $process.ProcessId + ")" + " - Creation date: " + $process.CreationDate); $process | Select-Object CommandLine | Format-Table -autosize -wrap}
