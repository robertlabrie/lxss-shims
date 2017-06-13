#!/usr/bin/powershell
<#
Assumes chocolatey installed version of atom in %USERPROFILE%
by: robert.labrie@gmail.com
#>

. "$(Split-Path $PSCommandPath -parent)/functions.ps1"  # include shim functions

$un = Get-WindowsUsername
$atomRoot = '/mnt/c/Users/Rob/AppData/Local/atom'
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

Write-Output $atomBin

$bits = $args
$bits[-1] = $args[-1] | ConvertTo-WindowsPath

& $atomBin $bits
