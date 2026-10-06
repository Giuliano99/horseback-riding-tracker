param([string]$SdkPath = $env:CONNECT_IQ_SDK)
$ErrorActionPreference = 'Stop'
if (-not $SdkPath) {
    $SdkPath = [Environment]::GetEnvironmentVariable('CONNECT_IQ_SDK', 'User')
}
if (-not $SdkPath -or -not (Test-Path -LiteralPath (Join-Path $SdkPath 'bin\monkeydo.bat'))) {
    throw 'Connect IQ SDK fehlt. -SdkPath oder CONNECT_IQ_SDK auf den SDK-Ordner setzen.'
}
$program = Join-Path (Split-Path -Parent $PSScriptRoot) 'bin\WesternRide.prg'
if (-not (Test-Path -LiteralPath $program -PathType Leaf)) {
    throw 'App fehlt. Zuerst scripts/build.ps1 erfolgreich ausfuehren.'
}
# Start the simulator through the Monkey C extension before invoking monkeydo.
& (Join-Path $SdkPath 'bin\monkeydo.bat') $program venu3s
if ($LASTEXITCODE -ne 0) { throw "Simulator-Aufruf fehlgeschlagen (Exitcode $LASTEXITCODE)." }
