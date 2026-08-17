param(
    [switch]$CleanGenerated
)

$ErrorActionPreference = 'Continue'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
Set-Location $root

Write-Host '[CLEAN] Stopping Gradle/Kotlin build daemons that can lock Android files...'

$gradlew = Join-Path $root 'android\gradlew.bat'
if (Test-Path $gradlew) {
    try { & $gradlew --stop | Out-Host } catch { }
}

# Stop only Java processes whose command line clearly belongs to Gradle/Kotlin
# build daemons. Do not kill unrelated Java applications.
try {
    Get-CimInstance Win32_Process -Filter "Name='java.exe' OR Name='javaw.exe'" | ForEach-Object {
        $cmd = [string]$_.CommandLine
        if ($cmd -match 'GradleDaemon|org\.gradle\.launcher\.daemon|kotlin-daemon|KotlinCompileDaemon') {
            Write-Host ("[CLEAN] Stopping locked build process PID {0}" -f $_.ProcessId)
            Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
        }
    }
} catch {
    Write-Host '[CLEAN] Process scan skipped; continuing with directory cleanup.'
}

Start-Sleep -Milliseconds 900

function Remove-WithRetry([string]$Path) {
    if (-not (Test-Path $Path)) { return }
    for ($i = 1; $i -le 5; $i++) {
        try {
            Remove-Item -LiteralPath $Path -Recurse -Force -ErrorAction Stop
            Write-Host "[CLEAN] Removed $Path"
            return
        } catch {
            if ($i -eq 5) { throw }
            Write-Host "[CLEAN] $Path is still locked. Retry $i/5..."
            Start-Sleep -Seconds 1
        }
    }
}

if ($CleanGenerated) {
    Remove-WithRetry (Join-Path $root 'build')
    Remove-WithRetry (Join-Path $root '.dart_tool')
    Remove-WithRetry (Join-Path $root 'android')
}

Write-Host '[OK] Gradle/Kotlin lock cleanup complete.'
