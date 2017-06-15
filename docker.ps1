#!/usr/bin/powershell
<#
by: robert.labrie@gmail.com
#>

. "$(Split-Path $PSCommandPath -parent)/functions.ps1"  # include shim functions

$bits = $args

# the last argument of a build is a path so we need to convert it
if ($bits[0] -eq 'build') { $bits[-1] = $args[-1] | ConvertTo-WindowsPath }


# for some reason, sometimes the process doesn't return to the shell so we put
# timeout out in front to force it
# & /usr/bin/timeout 1 $atomBin $bits
& "/mnt/c/Program Files/Docker/Docker/resources/bin/docker.exe" $bits
