<#
Using this file for useful PS snippets

To do:
Check PS remoting! https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/disable-psremoting?view=powershell-5.1

Check if winRM service is running. Big security risk.  If it is, what are the permissions? "Get-PSSessionConfiguration | Format-Table -Property Name, Permission -Auto"

Look for large CPU utilization over time.  Currently measuring cpu time in seconds.

Possible to looks in wmi repo programatically for powershell scripts?
gwmi -namespace root\subscription -list
__EventFilter
CommandLineEventConsumer
__FilterToConsumerBinding


Check PS logging
Make recommendations
Check reg for mshta, ps entries
Check reg for startup items
Check reg for bogus extension handlers?
#>

# Get-ServiceStatus returns service status if found, otherwise returns "Not found"
function Get-ServiceStatus ([string]$serviceName) {
    If (Get-Service $serviceName -ErrorAction SilentlyContinue) {
        If ((Get-Service $serviceName).Status -eq 'Running') {
            return "Running"
        }
        Else {
            return (Get-Service $serviceName).Status
        }
    }
    Else {
        return "Not found"
    }
}


Write-Host ("WinRM (Windows Remote Management) service: ")                                  -NoNewline
Write-Host (Get-ServiceStatus("WinRM"))                                                     -ForegroundColor Black -BackgroundColor White
Write-Host ("WinRS (Windows Remote Shell) service:      ")                                  -NoNewline
Write-Host (Get-ServiceStatus("WinRS"))                                                     -ForegroundColor Black -BackgroundColor White
Write-Host "`n"



# Check PS version
if (Get-Variable -name "PSVersionTable" -ErrorAction SilentlyContinue) {
    Write-Host ("You are running Powershell version " + $PSVersionTable.PSVersion.Major)    -ForegroundColor Black -BackgroundColor White
    Write-Host ($PSVersionTable | Out-String)
}
else {
    Write-Host ("PSVersionTable not found.  This likely means you are running Powershell version 1.")
}




# foreach ($process in (Get-CimInstance Win32_Process -Filter "name = 'powershell.exe'")) {Write-Host ($process.Name + " (PID:" + $process.ProcessId + ")" + " - Creation date: " + $process.CreationDate) -ForegroundColor Black -BackgroundColor White; $process | Select-Object CommandLine | Format-Table -autosize -wrap}


# Finds all powershell processes and lists PID - Creation date - Total processor time - Command line called at launch
$processes = (Get-CimInstance Win32_Process -Filter "name = 'powershell.exe'")

if (($processes | Measure-Object).Count -eq 1 -And $processes[0].ProcessId -eq $PID) {
    Write-Host ("This Powershell instance is the only instance of `"powershell.exe`"")      -NoNewline -ForegroundColor Black -BackgroundColor White
    Write-Host (" (" + $PID + ")")                                                          -NoNewline -ForegroundColor Black -BackgroundColor White
    Write-Host ""
}

foreach ($process in $processes) {
    if ($process.ProcessId -eq $PID) {continue}                                                #Skipping current powershell process running this script
    Write-Host ($process.Name)                                                              -NoNewline -ForegroundColor Black -BackgroundColor White
    Write-Host (" (PID:" + $process.ProcessId + ")")                                        -NoNewline -ForegroundColor Black -BackgroundColor White
    Write-Host (" - Creation date: " + $process.CreationDate)                               -NoNewline -ForegroundColor Black -BackgroundColor White
    Write-Host (" - Total Processor Time (in seconds): ")                                   -NoNewline -ForegroundColor Black -BackgroundColor White
    Write-Host (Get-Process -Id $process.ProcessId).CPU                                     -NoNewline -ForegroundColor Black -BackgroundColor White
    Write-Host ""
    # Dump full CommandLine used on initial Powershell.exe call
    $process | Select-Object CommandLine | Format-Table -autosize -wrap
}

