$ErrorActionPreference = 'Stop'
$pubspec = 'pubspec.yaml'
if (-not (Test-Path $pubspec)) { throw 'pubspec.yaml not found.' }
$missing = @()
$assetLines = Get-Content $pubspec | Where-Object { $_ -match '^\s*-\s+assets/' }
foreach ($line in $assetLines) {
    $asset = ($line -replace '^\s*-\s+', '').Trim()
    if (-not (Test-Path $asset)) { $missing += $asset }
}
if ($missing.Count -gt 0) {
    Write-Host '[ERROR] Missing Flutter assets:' -ForegroundColor Red
    $missing | ForEach-Object { Write-Host ('  - ' + $_) -ForegroundColor Red }
    exit 1
}
Write-Host ("[OK] Flutter assets verified: " + $assetLines.Count)
exit 0
