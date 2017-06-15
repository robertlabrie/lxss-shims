#!/usr/bin/powershell
<#
Assumes atom installed in %USERPROFILE%
by: robert.labrie@gmail.com
#>

. "$(Split-Path $PSCommandPath -parent)/functions.ps1"  # include shim functions

$un = Get-WindowsUsername
$atomRoot = "/mnt/c/Users/$($un)/AppData/Local/atom"
$atomVersion = ''

# get the latest version of atom
foreach ($d in Get-ChildItem $atomRoot)
{
  if (!$d.Name.StartsWith('app-')) { continue }
  if ($d.Name -gt $atomVersion) { $atomVersion = $d.Name }
}
if ($atomVersion -eq '')
{
  Write-Error "Unable to locate atom binary. Aborting."
  exit 1
}
$atomBin = "$($atomRoot)/$($atomVersion)/atom.exe"

$bits = $args

# assume the last array element was the target file name and convert to windows
$bits[-1] = $args[-1] | ConvertTo-WindowsPath

# for some reason, sometimes the process doesn't return to the shell so we put
# timeout out in front to force it
& /usr/bin/timeout 1 $atomBin $bits
