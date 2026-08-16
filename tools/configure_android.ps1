$ErrorActionPreference = 'Stop'

$manifest = 'android/app/src/main/AndroidManifest.xml'
if (-not (Test-Path $manifest)) { throw 'AndroidManifest.xml not found.' }

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$s = [System.IO.File]::ReadAllText((Resolve-Path $manifest))

if ($s -notmatch 'android.permission.INTERNET') {
    $s = [regex]::Replace(
        $s,
        '(<manifest\b[^>]*>)',
        '$1' + "`r`n    <uses-permission android:name=`"android.permission.INTERNET`" />",
        1
    )
}

# Optional PC/Wi-Fi mode uses a local HTTP backend. Phone-only AI uses HTTPS for
# the first model download and then works offline.
if ($s -notmatch 'android:usesCleartextTraffic=') {
    $s = [regex]::Replace(
        $s,
        '<application\b',
        '<application android:usesCleartextTraffic="true" android:networkSecurityConfig="@xml/network_security_config"',
        1
    )
} elseif ($s -notmatch 'android:networkSecurityConfig=') {
    $s = $s -replace 'android:usesCleartextTraffic="true"', 'android:usesCleartextTraffic="true" android:networkSecurityConfig="@xml/network_security_config"'
}
$s = $s -replace 'android:label="certi_on"', 'android:label="CERTI:ON"'

$xmlDir = 'android/app/src/main/res/xml'
New-Item -ItemType Directory -Force -Path $xmlDir | Out-Null
$networkConfig = @'
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config cleartextTrafficPermitted="true" />
</network-security-config>
'@
[System.IO.File]::WriteAllText((Join-Path (Resolve-Path $xmlDir) 'network_security_config.xml'), $networkConfig, $utf8NoBom)
[System.IO.File]::WriteAllText((Resolve-Path $manifest), $s, $utf8NoBom)

$gradle = 'android/app/build.gradle.kts'
if (-not (Test-Path $gradle)) { throw 'android/app/build.gradle.kts not found.' }

$g = [System.IO.File]::ReadAllText((Resolve-Path $gradle))

# Native JNI dependencies currently require API 26+ and Android NDK 28.2.13676358.
$g = $g -replace 'minSdk\s*=\s*flutter\.minSdkVersion', 'minSdk = 26'
$g = $g -replace 'minSdk\s*=\s*\d+', 'minSdk = 26'
$g = $g -replace 'ndkVersion\s*=\s*flutter\.ndkVersion', 'ndkVersion = "28.2.13676358"'
if ($g -notmatch 'ndkVersion\s*=') {
    $g = [regex]::Replace($g, 'android\s*\{', "android {`r`n    ndkVersion = `"28.2.13676358`"", 1)
}

# IMPORTANT (AGP 9 / Flutter 3.47+): resource shrinking is invalid when code
# shrinking is disabled. Explicitly disable BOTH for the release build.
# This fixes: "Removing unused resources requires unused code shrinking to be turned on."
$g = [regex]::Replace($g, '(?m)^\s*(isShrinkResources|shrinkResources)\s*=\s*(true|false)\s*$', '')
$g = [regex]::Replace($g, '(?m)^\s*(isMinifyEnabled|minifyEnabled)\s*=\s*(true|false)\s*$', '')

$releasePattern = 'release\s*\{'
if ($g -notmatch $releasePattern) { throw 'Release buildType block not found in build.gradle.kts.' }
$releaseSettings = @'
release {
            // CERTI:ON: keep native llama plugin packaging simple and deterministic.
            isMinifyEnabled = false
            isShrinkResources = false
'@
$g = [regex]::Replace($g, $releasePattern, $releaseSettings, 1)

[System.IO.File]::WriteAllText((Resolve-Path $gradle), $g, $utf8NoBom)

# Flutter 3.47 currently warns about plugins that still apply the Kotlin Gradle
# Plugin. The llama plugin does that, so keep Flutter's temporary legacy bridge on.
$gradleProps = 'android/gradle.properties'
if (Test-Path $gradleProps) {
    $gp = [System.IO.File]::ReadAllText((Resolve-Path $gradleProps))
    $lines = $gp -split "`r?`n" | Where-Object {
        $_ -notmatch '^android\.(newDsl|builtInKotlin)=' -and
        $_ -notmatch '^org\.gradle\.daemon=' -and
        $_ -notmatch '^kotlin\.compiler\.execution\.strategy=' -and
        $_ -notmatch '^kotlin\.incremental='
    }
    $gp = (($lines -join "`r`n").TrimEnd() +
        "`r`nandroid.newDsl=false" +
        "`r`nandroid.builtInKotlin=false" +
        "`r`norg.gradle.daemon=false" +
        "`r`nkotlin.compiler.execution.strategy=in-process" +
        "`r`nkotlin.incremental=false`r`n")
    [System.IO.File]::WriteAllText((Resolve-Path $gradleProps), $gp, $utf8NoBom)
}

# Keep rules are harmless while minify=false and make it safe to enable R8 later.
$proguard = 'android/app/proguard-rules.pro'
$rules = @'
-keep class com.write4me.llama_flutter_android.** { *; }
-keep class kotlin.jvm.functions.Function1
-keepclassmembers class * implements kotlin.jvm.functions.Function1 {
    public java.lang.Object invoke(java.lang.Object);
}
-keepclasseswithmembernames class * {
    native <methods>;
}
'@
[System.IO.File]::WriteAllText($proguard, $rules, $utf8NoBom)

# Final verification in the same pass: fewer helper files and fewer moving parts.
$verify = [System.IO.File]::ReadAllText((Resolve-Path $gradle))
$errors = @()
if ($verify -notmatch 'isMinifyEnabled\s*=\s*false') { $errors += 'isMinifyEnabled=false missing' }
if ($verify -notmatch 'isShrinkResources\s*=\s*false') { $errors += 'isShrinkResources=false missing' }
if ($verify -match 'isShrinkResources\s*=\s*true') { $errors += 'isShrinkResources=true still present' }
if ($verify -notmatch 'minSdk\s*=\s*26') { $errors += 'minSdk=26 missing' }
if ($verify -notmatch 'ndkVersion\s*=\s*"28\.2\.13676358"') { $errors += 'NDK 28.2.13676358 pin missing' }
if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Host "[ERROR] $_" -ForegroundColor Red }
    exit 1
}

Write-Host '[OK] Android config verified: INTERNET, API 26+, NDK 28.2.13676358.'
Write-Host '[OK] Release shrinking OFF; Gradle daemon OFF; Kotlin compiler in-process.'
