# Find all powershell processes and show command line used to launch
# 
# Check PS version
# Check PS logging
# Make recommendations
# 
# Check reg for mshta, ps entries
# Check reg for startup items
# Check reg for bogus extension handlers?
foreach($process in (Get-CimInstance Win32_Process -Filter "name = 'powershell.exe'")) {($process.Name + " (PID:" + $process.ProcessId + ")"); $process | Select-Object CommandLine | Format-Table -autosize -wrap}