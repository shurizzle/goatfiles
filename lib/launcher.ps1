$global:LIB = "${PSScriptRoot}/launcher.fnl"
$global:FENNEL = "${PSScriptRoot}/../fennel"
$global:GLOBALS = "*file*,*project*,pattern-quote,unpack"

Function Test-CommandExists
{
  Param ($command)

  $oldPreference = $ErrorActionPreference

  $ErrorActionPreference = 'stop'

  try
  {
    if (Get-Command $command)
    {
      return $true
    }
  } Catch
  {
  } Finally
  {
    $ErrorActionPreference=$oldPreference
  }
  return $false
}

if ((Test-CommandExists fennel) -and (fennel -e '(require :luv)' >$null 2>$null))
{
  fennel --globals $global:GLOBALS $global:LIB @args
} elseif ((Test-CommandExists lua) -and (lua -e "require 'luv'" >$null 2>$null))
{
  lua $global:FENNEL --globals $global:GLOBALS $global:LIB @args
} elseif ((Test-CommandExists luajit) -and (luajit -e "require 'luv'" >$null 2>$null))
{
  luajit $global:FENNEL --globals $global:GLOBALS $global:LIB @args
} elseif (Test-CommandExists nvim)
{
  nvim -u NONE --headless -l $global:FENNEL --globals $global:GLOBALS $global:LIB @args
} else
{
  Write-Error "Cannot find a valid lua version with luv support"
  $LASTEXITCODE = 1
}

exit $LASTEXITCODE
