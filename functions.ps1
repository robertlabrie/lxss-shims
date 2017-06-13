#!/usr/bin/powershell
function Get-FileSystems()
{
  $out = @{}
  $mount = /bin/mount
  foreach ($m in $mount)
  {
    if (!$m.Contains('lxfs')) { continue }
    $bits = $m.Split(' ')
    $out[$bits[2]] = $bits[0]
  }
  return $out
}

function Get-WindowsUsername()
{
  $username = (/mnt/c/Windows/System32/whoami.exe | Out-String).trim()
  if ($username -like '*\*') {
    $bits = $username.split('\')
    return $bits[1] # we don't want the machine/domain portion
  }
  return $username
}

function ConvertTo-WindowsPath()
{
  param(
      [Parameter(
          Position=0,
          Mandatory=$true,
          ValueFromPipeline=$true,
          ValueFromPipelineByPropertyName=$true)
      ]
      [string]$linuxPath
  )
  # Write-Output "Resolving $($linuxPath)"
  #if ($bits[2] == '/') { continue } # we'll default to root later
  #if ($bits[2] == '/mnt') { continue } # mnt handled specially

  #
  if ($linuxPath.StartsWith('/'))
  {
    # absolute, do nothing
    $linuxPath = $linuxPath
  }
  elseif ($linuxPath.StartsWith('./'))
  {
    # ./ prepend pwd
    $linuxPath = "$($ENV:PWD)$($linuxPath.SubString(1))"
  }
  else
  {
    # no path, assume local
    $linuxPath = "$($ENV:PWD)/$($linuxPath)"
  }
  # Write-Output "Absolute: $linuxPath"

  # You can't mount filesystems in the lxss so the only thing in /mnt is windows
  # drives so resolve them to windows paths and move on
  if ($linuxPath.StartsWith('/mnt'))
  {
    $windowsPath = $linuxPath.replace('/mnt/','')
    $windowsPath = "$($windowsPath.SubString(0,1)):$($windowsPath.SubString(1))"
    $windowsPath = $windowsPath.replace('/','\')
    return $windowsPath
  }

  # now that linuxPath is absolute, convert it to a windows path
  $windowsRoot = "C:\Users\$(Get-WindowsUsername)\AppData\Local\lxss"
  # Write-Output "windowsRoot: $windowsRoot"

  # if it wasn't in /mnt we need to scan the virtual filesystems
  $fs = Get-FileSystems
  foreach ($f in $fs.Keys)
  {
    if ($f -eq '/') { continue } # all paths will startwith / so we catch this
    if ($f -eq '/mnt') { continue } # handled above
    if ($linuxPath.StartsWith($f))
    {
      $windowsPath = "$($windowsRoot)\$($fs[$f])$($linuxPath.replace($f,'').replace('/','\'))"
      return $windowsPath
    }
  }

  # if we got all the way down here, it's off rootfs so handle it now
  $windowsPath = "$($windowsRoot)\rootfs$($linuxPath.replace('/','\'))"
  return $windowsPath
}

#ConvertTo-WindowsPath '/home/rob'
#ConvertTo-WindowsPath '/etc/foo'
#ConvertTo-WindowsPath '/fuzz'
#ConvertTo-WindowsPath '/mnt/c/Users/Rob/Documents/shims/functions.ps1'
#ConvertTo-WindowsPath '/home/rob/derp'
#ConvertTo-WindowsPath '/etc/foobar'
