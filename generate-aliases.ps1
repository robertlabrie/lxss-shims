#!/usr/bin/powershell

. "$(Split-Path $PSCommandPath -parent)/functions.ps1"  # include shim functions

$un = Get-WindowsUsername

# write out the boiler plate
Write-Output "shopt -s cdable_vars"
Write-Output "export w=/mnt/c/Users/$($un)"
$basePath = (Split-Path $PSCommandPath -parent)
foreach ($i in Get-ChildItem $basePath) {
  if ($i.Extension -ne '.ps1') { continue }
  if ($i.Name -eq 'functions.ps1') { continue }
  if ($i.Name -eq 'generate-aliases.ps1') { continue }
  Write-Output "alias $($i.BaseName)='$basePath/$($i.Name)'"
}
