param(
  [string]$ProjectRoot = ""
)

$ErrorActionPreference = "Stop"
$repo = "DK8832/innovation"

$versions = [ordered]@{
  "v0.1.0"  = "certi_on_ogq_ultimate"
  "v0.2.0"  = "certi_on_ogq"
  "v0.3.0"  = "certi_on_ogq_ultimate1"
  "v0.4.0"  = "certi_on_ogq_ultimate2"
  "v0.5.0"  = "certi_on_ogq_ultimate3"
  "v0.6.0"  = "certi_on_ogq_ultimate4"
  "v0.7.0"  = "z_real_final_final_final_certi_on_ogq_ai_fixed"
  "v0.8.0"  = "CERTI_ON_OGQ_FULL_FIXED"
  "v0.9.0"  = "CERTI_ON_OGQ_FULL_FIXED_V2"
  "v0.10.0" = "CERTI_ON_OGQ_LOCAL_AI_SMART"
  "v0.11.0" = "CERTI_ON_OGQ_LOCAL_AI_SMART_V2"
  "v0.12.0" = "CERTI_ON_OGQ_ORIGINAL_LOCAL_QWEN14B"
  "v0.13.0" = "CERTI_ON_OGQ_QWEN14B_SMART_CHAT_FIXED"
  "v0.14.0" = "CERTI_ON_OGQ_QWEN14B_SMART_CHAT_FIXED_V2"
  "v0.15.0" = "FINAL_ULTIMATE_CERTI_ON_OGQ_AI_MODEL_SELECTOR_NO_TIMEOUT"
  "v0.16.0" = "FINAL_FINAL_ULTIMATE_CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED"
  "v0.17.0" = "CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V2"
  "v0.18.0" = "CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V3"
  "v0.19.0" = "CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V4"
  "v0.20.0" = "CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V5"
  "v0.21.0" = "CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V6"
  "v0.22.0" = "CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V7"
  "v0.23.0" = "CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V8"
  "v1.0.0"  = "CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V9"
}

function Find-Gh {
  $cmd = Get-Command gh -ErrorAction SilentlyContinue
  if ($cmd) { return $cmd.Source }

  $candidates = @(
    "$env:ProgramFiles\GitHub CLI\gh.exe",
    "${env:ProgramFiles(x86)}\GitHub CLI\gh.exe",
    "$env:LOCALAPPDATA\Programs\GitHub CLI\gh.exe"
  )
  foreach ($p in $candidates) {
    if ($p -and (Test-Path $p)) { return $p }
  }

  if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "[SETUP] GitHub CLI(gh)가 없어 자동 설치합니다..." -ForegroundColor Yellow
    winget install --id GitHub.cli -e --accept-package-agreements --accept-source-agreements
    foreach ($p in $candidates) {
      if ($p -and (Test-Path $p)) { return $p }
    }
  }
  throw "GitHub CLI(gh)를 찾을 수 없습니다. https://cli.github.com/ 에서 설치 후 다시 실행하세요."
}

function Resolve-ProjectRoot {
  param([string]$Requested)

  if ($Requested -and (Test-Path (Join-Path $Requested "CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V9"))) {
    return (Resolve-Path $Requested).Path
  }

  $here = (Get-Location).Path
  if (Test-Path (Join-Path $here "CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V9")) {
    return $here
  }

  $scriptDir = Split-Path -Parent $MyInvocation.ScriptName
  if ($scriptDir -and (Test-Path (Join-Path $scriptDir "CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V9"))) {
    return $scriptDir
  }

  Add-Type -AssemblyName System.Windows.Forms
  $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
  $dialog.Description = "24개 CERTI:ON 프로젝트 폴더가 들어있는 상위 폴더를 선택하세요."
  $dialog.ShowNewFolderButton = $false
  if ($dialog.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) {
    throw "프로젝트 폴더 선택이 취소되었습니다."
  }
  if (-not (Test-Path (Join-Path $dialog.SelectedPath "CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V9"))) {
    throw "선택한 폴더에서 V9 프로젝트를 찾지 못했습니다."
  }
  return $dialog.SelectedPath
}

Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host " CERTI:ON 24 VERSION -> GitHub Release Assets Publisher" -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host ""

$ProjectRoot = Resolve-ProjectRoot $ProjectRoot
Write-Host "[OK] 프로젝트 상위 폴더: $ProjectRoot" -ForegroundColor Green

$missing = @()
foreach ($pair in $versions.GetEnumerator()) {
  if (-not (Test-Path (Join-Path $ProjectRoot $pair.Value))) {
    $missing += "$($pair.Key) -> $($pair.Value)"
  }
}
if ($missing.Count -gt 0) {
  Write-Host "[ERROR] 다음 프로젝트 폴더가 없습니다:" -ForegroundColor Red
  $missing | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
  throw "24개 폴더 검증 실패"
}
Write-Host "[OK] 24/24 프로젝트 폴더 확인 완료" -ForegroundColor Green

$gh = Find-Gh
Write-Host "[OK] GitHub CLI: $gh" -ForegroundColor Green

& $gh auth status --hostname github.com *> $null
if ($LASTEXITCODE -ne 0) {
  Write-Host "[AUTH] GitHub 로그인이 필요합니다. 브라우저 인증을 한 번 진행합니다." -ForegroundColor Yellow
  & $gh auth login --hostname github.com --git-protocol https --web
  if ($LASTEXITCODE -ne 0) { throw "GitHub 로그인 실패" }
}
Write-Host "[OK] GitHub 인증 완료" -ForegroundColor Green

$work = Join-Path $env:TEMP ("CERTION_RELEASE_UPLOAD_" + [Guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path $work | Out-Null

$excludeDirs = @(
  ".git", ".dart_tool", "build", ".gradle", ".idea", "node_modules",
  "OUTPUT", "APK_OUTPUT", "dist", "logs"
)
$excludeFiles = @(".env", "local.properties")

$ok = 0
$failed = @()

try {
  $index = 0
  foreach ($pair in $versions.GetEnumerator()) {
    $index++
    $tag = $pair.Key
    $folder = $pair.Value
    $src = Join-Path $ProjectRoot $folder
    $stage = Join-Path $work $tag
    $zip = Join-Path $work ("CERTI_ON_{0}_{1}.zip" -f $tag.Replace(".","_"), $folder)

    Write-Host ""
    Write-Host "[$index/24] $tag <- $folder" -ForegroundColor Cyan

    New-Item -ItemType Directory -Force -Path $stage | Out-Null

    $xd = @()
    foreach ($d in $excludeDirs) { $xd += @("/XD", (Join-Path $src $d)) }
    $xf = @()
    foreach ($f in $excludeFiles) { $xf += @("/XF", $f) }

    $roboArgs = @($src, $stage, "/E", "/R:1", "/W:1", "/NFL", "/NDL", "/NJH", "/NJS", "/NP") + $xd + $xf
    & robocopy @roboArgs | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy 실패: $tag (code=$LASTEXITCODE)" }

    Get-ChildItem $stage -Recurse -Force -File | Where-Object {
      $_.Name -eq ".env" -or $_.Name -eq "local.properties"
    } | Remove-Item -Force -ErrorAction SilentlyContinue

    if (Test-Path $zip) { Remove-Item $zip -Force }
    Compress-Archive -Path (Join-Path $stage "*") -DestinationPath $zip -CompressionLevel Optimal

    & $gh release view $tag --repo $repo *> $null
    if ($LASTEXITCODE -ne 0) {
      Write-Host "  [CREATE] Release $tag 생성" -ForegroundColor Yellow
      & $gh release create $tag --repo $repo --title $tag --target main --notes "CERTI:ON $tag"
      if ($LASTEXITCODE -ne 0) { throw "Release 생성 실패: $tag" }
    }

    Write-Host "  [UPLOAD] $([Math]::Round((Get-Item $zip).Length / 1MB, 2)) MB" -ForegroundColor Gray
    & $gh release upload $tag $zip --repo $repo --clobber
    if ($LASTEXITCODE -ne 0) {
      $failed += $tag
      Write-Host "  [FAIL] $tag" -ForegroundColor Red
    } else {
      $ok++
      Write-Host "  [PASS] $tag Asset 업로드 완료" -ForegroundColor Green
    }

    Remove-Item $stage -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item $zip -Force -ErrorAction SilentlyContinue
  }
}
finally {
  Remove-Item $work -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host " 완료: $ok / 24" -ForegroundColor $(if ($ok -eq 24) {"Green"} else {"Yellow"})
Write-Host "=======================================================" -ForegroundColor Cyan

if ($failed.Count -gt 0) {
  Write-Host "실패 버전: $($failed -join ', ')" -ForegroundColor Red
  exit 1
}

Write-Host ""
Write-Host "GitHub Releases:" -ForegroundColor White
Write-Host "https://github.com/DK8832/innovation/releases" -ForegroundColor Blue
Start-Process "https://github.com/DK8832/innovation/releases"
Write-Host ""
Write-Host "[SUCCESS] 24개 버전의 실제 프로젝트 소스 ZIP Asset 업로드가 끝났습니다." -ForegroundColor Green
