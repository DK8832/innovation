param([int]$Port = 8787)
$ErrorActionPreference = 'Stop'
$ruleName = "CERTI:ON Local AI TCP $Port"

try {
    $existing = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue | Where-Object { $_.Enabled -eq 'True' }
    if ($existing) {
        Write-Host "[OK] Windows Firewall rule already exists: $ruleName"
        exit 0
    }
} catch {}

$command = @"
`$ErrorActionPreference='Stop';
Get-NetFirewallRule -DisplayName '$ruleName' -ErrorAction SilentlyContinue | Remove-NetFirewallRule -ErrorAction SilentlyContinue;
New-NetFirewallRule -DisplayName '$ruleName' -Direction Inbound -Action Allow -Protocol TCP -LocalPort $Port -Profile Any -RemoteAddress LocalSubnet | Out-Null;
"@

try {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    $isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if ($isAdmin) {
        Invoke-Expression $command
    } else {
        Write-Host '[INFO] Windows Firewall permission is needed once for phone-to-PC Wi-Fi AI.'
        Write-Host '[INFO] Accept the Windows administrator/UAC prompt.'
        $encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($command))
        $p = Start-Process powershell.exe -Verb RunAs -Wait -PassThru -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-EncodedCommand',$encoded)
        if ($p.ExitCode -ne 0) { throw "elevated firewall setup failed with exit code $($p.ExitCode)" }
    }

    $check = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
    if (-not $check) { throw 'firewall rule verification failed' }
    Write-Host "[OK] Windows Firewall allows TCP $Port from the local subnet only."
    exit 0
} catch {
    Write-Host "[WARN] Firewall rule was not created: $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host '[WARN] The app can still use phone-only AI, but PC Wi-Fi AI may be blocked by Windows Firewall.' -ForegroundColor Yellow
    exit 2
}
