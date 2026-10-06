param([string]$SdkPath = $env:CONNECT_IQ_SDK)
$ErrorActionPreference = 'Stop'
if (-not $SdkPath) { $SdkPath = [Environment]::GetEnvironmentVariable('CONNECT_IQ_SDK', 'User') }
& (Join-Path $PSScriptRoot 'build.ps1') -SdkPath $SdkPath -UnitTests
$program = Join-Path (Split-Path -Parent $PSScriptRoot) 'bin\WesternRideTests.prg'
& (Join-Path $SdkPath 'bin\monkeydo.bat') $program venu3s /t
if ($LASTEXITCODE -ne 0) { throw "Simulator-Tests fehlgeschlagen (Exitcode $LASTEXITCODE)." }
