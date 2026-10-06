param(
    [string]$SdkPath = $env:CONNECT_IQ_SDK,
    [string]$DeveloperKey = $env:CONNECT_IQ_DEVELOPER_KEY
)
$ErrorActionPreference = 'Stop'
if (-not $SdkPath) {
    $SdkPath = [Environment]::GetEnvironmentVariable('CONNECT_IQ_SDK', 'User')
}
if (-not $DeveloperKey) {
    $DeveloperKey = [Environment]::GetEnvironmentVariable('CONNECT_IQ_DEVELOPER_KEY', 'User')
}
if (-not $SdkPath -or -not (Test-Path -LiteralPath (Join-Path $SdkPath 'bin\monkeyc.bat'))) {
    throw 'Connect IQ SDK fehlt. -SdkPath oder CONNECT_IQ_SDK auf den SDK-Ordner setzen.'
}
if (-not $DeveloperKey -or -not (Test-Path -LiteralPath $DeveloperKey -PathType Leaf)) {
    throw 'Entwicklerschluessel fehlt. -DeveloperKey oder CONNECT_IQ_DEVELOPER_KEY auf eine DER-Datei setzen.'
}
$projectRoot = Split-Path -Parent $PSScriptRoot
$outputDirectory = Join-Path $projectRoot 'bin'
New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
Push-Location -LiteralPath $projectRoot
try {
    & (Join-Path $SdkPath 'bin\monkeyc.bat') -f monkey.jungle -d venu3s -y $DeveloperKey -o (Join-Path $outputDirectory 'WesternRide.prg')
    if ($LASTEXITCODE -ne 0) { throw "Monkey-C-Build fehlgeschlagen (Exitcode $LASTEXITCODE)." }
} finally {
    Pop-Location
}
