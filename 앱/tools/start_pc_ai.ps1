param(
    [int]$Port = 8787,
    [string]$ExpectedVersion = 'v9-one-click-optimized'
)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$backendDir = Join-Path $root 'backend'
$logDir = Join-Path $root 'logs'
New-Item -ItemType Directory -Force -Path $logDir | Out-Null

function Test-Ollama {
    try {
        $r = Invoke-RestMethod -Uri 'http://127.0.0.1:11434/api/version' -TimeoutSec 2
        return [bool]$r.version
    } catch { return $false }
}

function Test-Backend {
    try {
        $r = Invoke-RestMethod -Uri "http://127.0.0.1:$Port/health" -TimeoutSec 2
        return ($r.ok -eq $true -and [string]$r.backendVersion -eq $ExpectedVersion)
    } catch { return $false }
}

$node = Get-Command node -ErrorAction SilentlyContinue
if (-not $node) { throw 'Node.js was not found in PATH.' }
$ollama = Get-Command ollama -ErrorAction SilentlyContinue
if (-not $ollama) { throw 'Ollama was not found in PATH.' }

# Start Ollama only when its local API is not already alive.
if (-not (Test-Ollama)) {
    Write-Host '[PC AI] Starting Ollama...'
    Start-Process -FilePath $ollama.Source -ArgumentList @('serve') -WindowStyle Minimized | Out-Null
    $ready = $false
    for ($i=0; $i -lt 30; $i++) {
        Start-Sleep -Seconds 1
        if (Test-Ollama) { $ready = $true; break }
    }
    if (-not $ready) { throw 'Ollama API did not become ready within 30 seconds.' }
}
Write-Host '[OK] Ollama API ready: http://127.0.0.1:11434'

# Verify the fast/default model. Other models remain selectable if installed.
try {
    $tags = Invoke-RestMethod -Uri 'http://127.0.0.1:11434/api/tags' -TimeoutSec 5
    $names = @($tags.models | ForEach-Object { if ($_.name) { [string]$_.name } else { [string]$_.model } })
    if ($names -notcontains 'qwen3:4b') {
        Write-Host '[WARN] qwen3:4b is not installed. PC mode can still use another installed Qwen3 model.' -ForegroundColor Yellow
    } else {
        Write-Host '[OK] qwen3:4b installed.'
    }
} catch {
    Write-Host '[WARN] Could not list Ollama models.' -ForegroundColor Yellow
}

# Stop a stale server on this dedicated port so the phone never talks to an old backend.
try {
    $owners = @(Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -Unique)
    foreach ($pidValue in $owners) {
        if ($pidValue -and $pidValue -ne $PID) {
            Write-Host "[PC AI] Stopping stale TCP $Port process PID $pidValue..."
            Stop-Process -Id $pidValue -Force -ErrorAction SilentlyContinue
        }
    }
} catch {}
Start-Sleep -Milliseconds 700

$outLog = Join-Path $logDir 'backend.out.log'
$errLog = Join-Path $logDir 'backend.err.log'
Remove-Item $outLog,$errLog -Force -ErrorAction SilentlyContinue
Start-Process -FilePath $node.Source -ArgumentList @('server.mjs') -WorkingDirectory $backendDir -WindowStyle Minimized -RedirectStandardOutput $outLog -RedirectStandardError $errLog | Out-Null

$backendReady = $false
for ($i=0; $i -lt 20; $i++) {
    Start-Sleep -Seconds 1
    if (Test-Backend) { $backendReady = $true; break }
}
if (-not $backendReady) {
    Write-Host '[ERROR] CERTI:ON backend did not start correctly.' -ForegroundColor Red
    if (Test-Path $errLog) { Get-Content $errLog -Tail 20 | ForEach-Object { Write-Host $_ } }
    exit 1
}
Write-Host "[OK] CERTI:ON PC AI backend $ExpectedVersion ready."

$lanIp = & (Join-Path $PSScriptRoot 'get_lan_ip.ps1')
if ($LASTEXITCODE -ne 0 -or -not $lanIp) {
    Write-Host '[WARN] Could not detect Wi-Fi/LAN IPv4 automatically.' -ForegroundColor Yellow
    exit 2
}
$address = "http://$lanIp`:$Port"
Set-Content -Path (Join-Path $root 'PC_AI_ADDRESS.txt') -Value $address -Encoding ASCII
Write-Host ''
Write-Host '=========================================='
Write-Host '[READY] PHONE PC-AI SERVER ADDRESS'
Write-Host $address -ForegroundColor Cyan
Write-Host '=========================================='
Write-Output $address
exit 0
