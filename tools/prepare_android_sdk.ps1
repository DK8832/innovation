$ErrorActionPreference = 'Stop'

function Fail([string]$message) {
    Write-Host "[ERROR] $message" -ForegroundColor Red
    exit 1
}

Write-Host '[PREP] Checking Android SDK packages required by on-device AI (NDK 28.2)...'

$candidates = @()
if ($env:ANDROID_SDK_ROOT) { $candidates += $env:ANDROID_SDK_ROOT }
if ($env:ANDROID_HOME) { $candidates += $env:ANDROID_HOME }
if ($env:LOCALAPPDATA) { $candidates += (Join-Path $env:LOCALAPPDATA 'Android\Sdk') }

$sdkRoot = $null
foreach ($candidate in $candidates | Select-Object -Unique) {
    if ($candidate -and (Test-Path $candidate)) {
        $sdkRoot = (Resolve-Path $candidate).Path
        break
    }
}
if (-not $sdkRoot) {
    Fail 'Android SDK was not found. Run flutter doctor -v and install Android command-line tools.'
}
Write-Host "[OK] Android SDK: $sdkRoot"

$cmdlineRoot = Join-Path $sdkRoot 'cmdline-tools'
if (-not (Test-Path $cmdlineRoot)) {
    Fail "Android Command-line Tools are missing: $cmdlineRoot"
}

$sdkManagers = @(Get-ChildItem -Path $cmdlineRoot -Filter 'sdkmanager.bat' -Recurse -File -ErrorAction SilentlyContinue)
if ($sdkManagers.Count -eq 0) {
    Fail "sdkmanager.bat was not found under $cmdlineRoot. Install Android Command-line Tools."
}

$sdkManager = $sdkManagers | Where-Object { $_.FullName -match '[\\/]latest[\\/]bin[\\/]sdkmanager\.bat$' } | Select-Object -First 1
if (-not $sdkManager) {
    $sdkManager = $sdkManagers | Sort-Object FullName -Descending | Select-Object -First 1
}
$sdkManagerPath = $sdkManager.FullName
Write-Host "[OK] sdkmanager: $sdkManagerPath"

$platformDir = Join-Path $sdkRoot 'platforms\android-35'
$platformJar = Join-Path $platformDir 'android.jar'
$buildToolsDir = Join-Path $sdkRoot 'build-tools\35.0.0'
$ndkDir = Join-Path $sdkRoot 'ndk\28.2.13676358'
$cmakeDir = Join-Path $sdkRoot 'cmake\3.22.1'

# Previous interrupted SDK downloads can leave a folder that looks installed but is unusable.
if ((Test-Path $platformDir) -and -not (Test-Path $platformJar)) {
    Write-Host '[FIX] Removing incomplete Android SDK Platform 35 folder...'
    Remove-Item -Recurse -Force $platformDir
}
if ((Test-Path $buildToolsDir) -and -not (Test-Path (Join-Path $buildToolsDir 'aapt2.exe'))) {
    Write-Host '[FIX] Removing incomplete Build-Tools 35.0.0 folder...'
    Remove-Item -Recurse -Force $buildToolsDir
}
if ((Test-Path $ndkDir) -and -not (Test-Path (Join-Path $ndkDir 'source.properties'))) {
    Write-Host '[FIX] Removing incomplete NDK 28.2.13676358 folder...'
    Remove-Item -Recurse -Force $ndkDir
}
if ((Test-Path $cmakeDir) -and -not (Test-Path (Join-Path $cmakeDir 'bin\cmake.exe'))) {
    Write-Host '[FIX] Removing incomplete CMake 3.22.1 folder...'
    Remove-Item -Recurse -Force $cmakeDir
}

function Get-MissingPackages {
    $items = New-Object System.Collections.Generic.List[string]
    if (-not (Test-Path $platformJar)) { $items.Add('platforms;android-35') }
    if (-not (Test-Path (Join-Path $buildToolsDir 'aapt2.exe'))) { $items.Add('build-tools;35.0.0') }
    if (-not (Test-Path (Join-Path $ndkDir 'source.properties'))) { $items.Add('ndk;28.2.13676358') }
    if (-not (Test-Path (Join-Path $cmakeDir 'bin\cmake.exe'))) { $items.Add('cmake;3.22.1') }
    return $items
}

$missing = @(Get-MissingPackages)
if ($missing.Count -gt 0) {
    Write-Host ('[INFO] Missing SDK packages: ' + ($missing -join ', '))
    Write-Host '[INFO] Downloading missing packages. First setup may take several minutes.'

    $ok = $false
    for ($attempt = 1; $attempt -le 2; $attempt++) {
        Write-Host "[INFO] sdkmanager attempt $attempt/2..."
        & $sdkManagerPath --sdk_root=$sdkRoot @missing
        if ($LASTEXITCODE -eq 0) {
            $remaining = @(Get-MissingPackages)
            if ($remaining.Count -eq 0) { $ok = $true; break }
            Write-Host ('[WARN] Packages still missing after attempt: ' + ($remaining -join ', ')) -ForegroundColor Yellow
            $missing = $remaining
        } else {
            Write-Host "[WARN] sdkmanager exit code: $LASTEXITCODE" -ForegroundColor Yellow
        }
        Start-Sleep -Seconds 2
    }

    if (-not $ok) {
        Write-Host ''
        Write-Host '[HINT] Run this once, accept all required Android licenses, then retry:' -ForegroundColor Yellow
        Write-Host '       flutter doctor --android-licenses' -ForegroundColor Yellow
        Write-Host '[HINT] Also check internet connection and free disk space.' -ForegroundColor Yellow
        exit 1
    }
}

$checks = @(
    @{Name='Android SDK Platform 35'; Path=$platformJar},
    @{Name='Build-Tools 35.0.0'; Path=(Join-Path $buildToolsDir 'aapt2.exe')},
    @{Name='NDK 28.2.13676358'; Path=(Join-Path $ndkDir 'source.properties')},
    @{Name='CMake 3.22.1'; Path=(Join-Path $cmakeDir 'bin\cmake.exe')}
)
foreach ($check in $checks) {
    if (-not (Test-Path $check.Path)) { Fail ("Missing after install: " + $check.Name) }
    Write-Host ('[OK] ' + $check.Name)
}

Write-Host '[OK] Android native build prerequisites are ready.'
exit 0
