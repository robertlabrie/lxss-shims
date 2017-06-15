#!/usr/bin/powershell
<#
starts the default windows handler for the specified file
by: robert.labrie@gmail.com
#>
. "$(Split-Path $PSCommandPath -parent)/functions.ps1"  # include shim functions

$target = $args[0]
if ($target -eq '.') { $target = './' } # start . is a natural windows thing

$target = ConvertTo-WindowsPath $target
& /mnt/c/Windows/System32/cmd.exe /c start $target
