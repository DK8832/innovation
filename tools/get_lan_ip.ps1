$ErrorActionPreference = 'SilentlyContinue'

# Prefer the active physical Wi-Fi adapter because CERTI:ON PC mode is intended
# to be used by a phone on the same Wi-Fi. Avoid virtual/VPN adapters first.
$preferred = Get-NetIPConfiguration | Where-Object {
  $_.NetAdapter.Status -eq 'Up' -and
  $_.IPv4DefaultGateway -ne $null -and
  $_.IPv4Address -ne $null -and
  $_.InterfaceAlias -match 'Wi-Fi|WLAN|Wireless' -and
  $_.InterfaceAlias -notmatch 'vEthernet|Loopback|WSL|Docker|VPN|Tailscale|ZeroTier'
} | ForEach-Object { $_.IPv4Address.IPAddress } | Where-Object {
  $_ -and $_ -notlike '169.254.*' -and $_ -ne '127.0.0.1'
} | Select-Object -First 1

if (-not $preferred) {
  $preferred = Get-NetIPConfiguration | Where-Object {
    $_.NetAdapter.Status -eq 'Up' -and
    $_.IPv4DefaultGateway -ne $null -and
    $_.IPv4Address -ne $null -and
    $_.InterfaceAlias -notmatch 'vEthernet|Loopback|WSL|Docker|VPN|Tailscale|ZeroTier'
  } | ForEach-Object { $_.IPv4Address.IPAddress } | Where-Object {
    $_ -and $_ -notlike '169.254.*' -and $_ -ne '127.0.0.1'
  } | Select-Object -First 1
}

if (-not $preferred) {
  $preferred = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {
    $_.IPAddress -notlike '127.*' -and
    $_.IPAddress -notlike '169.254.*' -and
    $_.InterfaceAlias -notmatch 'vEthernet|Loopback|WSL|Docker|VPN|Tailscale|ZeroTier'
  } | Sort-Object InterfaceMetric | Select-Object -ExpandProperty IPAddress -First 1
}

if ($preferred) { Write-Output $preferred; exit 0 }
exit 1
