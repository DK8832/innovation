@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"
title CERTI:ON - ONE CLICK BUILD + PHONE UPDATE + WIFI AI

set "APP_ID=com.example.certi_on"
set "APK_SOURCE=build\app\outputs\flutter-apk\app-release.apk"
set "APK_OUTPUT=OUTPUT\CERTI_ON.apk"
set "PC_PORT=8787"
set "DEFAULT_PC_MODEL=qwen3:4b"
set "BUILD_OK=0"
set "INSTALL_OK=0"
set "PC_AI_OK=0"

if not exist OUTPUT mkdir OUTPUT
if not exist logs mkdir logs

echo ================================================
echo CERTI:ON V9 - ONE CLICK ALL-IN-ONE
echo ================================================
echo 1. Flutter APK build
echo 2. Connected Android phone update install
echo 3. Windows firewall for Wi-Fi AI
echo 4. Ollama + CERTI:ON PC AI server start
echo 5. App opens automatically on the phone
echo ================================================
echo.

where flutter >nul 2>nul
if errorlevel 1 (
  echo [STOP] Flutter was not found in PATH.
  echo Run flutter --version in PowerShell first.
  goto :fatal
)
where java >nul 2>nul
if errorlevel 1 (
  echo [STOP] Java 17+ was not found in PATH.
  goto :fatal
)

rem Make adb available even when platform-tools is not in PATH.
where adb >nul 2>nul
if errorlevel 1 (
  if exist "%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe" (
    set "PATH=%LOCALAPPDATA%\Android\Sdk\platform-tools;!PATH!"
  )
)

for /f "tokens=3" %%V in ('java -version 2^>^&1 ^| findstr /i "version"') do set "JAVA_VER=%%~V"
echo [INFO] Java: !JAVA_VER!
for /f "delims=" %%V in ('flutter --version 2^>nul ^| findstr /b "Flutter"') do if not defined FLUTTER_VER set "FLUTTER_VER=%%V"
echo [INFO] !FLUTTER_VER!
echo.

set "LAN_IP="
for /f "usebackq delims=" %%I in (`powershell -NoProfile -ExecutionPolicy Bypass -File tools\get_lan_ip.ps1 2^>nul`) do if not defined LAN_IP set "LAN_IP=%%I"
set "API_DEFINE="
if defined LAN_IP (
  set "PC_URL=http://!LAN_IP!:%PC_PORT%"
  set "API_DEFINE=--dart-define=CERTI_API_BASE_URL=!PC_URL!"
  echo [OK] Wi-Fi/LAN IPv4: !LAN_IP!
  echo [OK] App default PC AI address: !PC_URL!
) else (
  set "PC_URL="
  echo [WARN] LAN IPv4 could not be detected. Phone-only AI will still work.
)
echo.

echo [1/7] Checking Android SDK / NDK / CMake...
powershell -NoProfile -ExecutionPolicy Bypass -File tools\prepare_android_sdk.ps1
if errorlevel 1 goto :fatal

echo [2/7] Verifying app data and image assets...
powershell -NoProfile -ExecutionPolicy Bypass -File tools\verify_assets.ps1
if errorlevel 1 goto :fatal

echo [3/7] Preparing Android build wrapper...
powershell -NoProfile -ExecutionPolicy Bypass -File tools\stop_gradle_locks.ps1
if errorlevel 1 goto :fatal
if not exist android\app\build.gradle.kts (
  call :regenerate_android
  if errorlevel 1 goto :fatal
) else (
  echo [FAST] Existing Android wrapper reused. No unnecessary regeneration.
)
powershell -NoProfile -ExecutionPolicy Bypass -File tools\configure_android.ps1
if errorlevel 1 goto :fatal

echo [4/7] Resolving Flutter packages and native Korean UTF-8 patch...
call flutter pub get
if errorlevel 1 goto :fatal
powershell -NoProfile -ExecutionPolicy Bypass -File tools\patch_llama_utf8.ps1
if errorlevel 1 goto :fatal

echo [5/7] Building optimized ARM64 release APK...
call :build_release
if errorlevel 1 (
  echo.
  echo [SELF-REPAIR] First build failed. Cleaning generated Android/build state and retrying once...
  powershell -NoProfile -ExecutionPolicy Bypass -File tools\stop_gradle_locks.ps1 -CleanGenerated
  if errorlevel 1 goto :fatal
  call :regenerate_android
  if errorlevel 1 goto :fatal
  powershell -NoProfile -ExecutionPolicy Bypass -File tools\configure_android.ps1
  if errorlevel 1 goto :fatal
  call flutter pub get
  if errorlevel 1 goto :fatal
  powershell -NoProfile -ExecutionPolicy Bypass -File tools\patch_llama_utf8.ps1
  if errorlevel 1 goto :fatal
  call :build_release
  if errorlevel 1 goto :fatal
)

if not exist "%APK_SOURCE%" (
  echo [ERROR] Flutter build finished but APK was not found: %APK_SOURCE%
  goto :fatal
)
copy /Y "%APK_SOURCE%" "%APK_OUTPUT%" >nul
set "BUILD_OK=1"
for %%A in ("%APK_OUTPUT%") do set "APK_SIZE=%%~zA"
echo [OK] APK created: %CD%\%APK_OUTPUT%
echo [OK] APK size: !APK_SIZE! bytes

echo [6/7] Updating the connected Android phone...
where adb >nul 2>nul
if errorlevel 1 (
  echo [WARN] adb was not found. APK is ready, but phone auto-update was skipped.
) else (
  set "DEVICE_ID="
  for /f "skip=1 tokens=1,2" %%A in ('adb devices') do (
    if "%%B"=="device" if not defined DEVICE_ID set "DEVICE_ID=%%A"
  )
  if not defined DEVICE_ID (
    echo [WARN] No authorized Android phone detected. APK is ready for manual install.
    adb devices
  ) else (
    echo [OK] Android device: !DEVICE_ID!
    for /f "delims=" %%A in ('adb -s !DEVICE_ID! shell getprop ro.product.cpu.abi') do set "PHONE_ABI=%%A"
    echo [INFO] Phone ABI: !PHONE_ABI!
    echo !PHONE_ABI! | findstr /i "arm64" >nul
    if errorlevel 1 (
      echo [WARN] Phone is not ARM64. On-device llama AI requires ARM64.
    ) else (
      adb -s !DEVICE_ID! install -r "%APK_OUTPUT%"
      if errorlevel 1 (
        echo [ERROR] Phone update install failed.
        echo [IMPORTANT] CERTI:ON will NOT auto-uninstall the old app because uninstalling would delete downloaded phone AI models.
        echo [INFO] APK remains at: %CD%\%APK_OUTPUT%
      ) else (
        set "INSTALL_OK=1"
        adb -s !DEVICE_ID! shell monkey -p %APP_ID% -c android.intent.category.LAUNCHER 1 >nul 2>nul
        echo [OK] CERTI:ON updated and opened on the phone.
      )
    )
  )
)

echo [7/7] Starting PC Wi-Fi AI automatically...
powershell -NoProfile -ExecutionPolicy Bypass -File tools\ensure_firewall.ps1 -Port %PC_PORT%
set "FW_EXIT=!ERRORLEVEL!"
if !FW_EXIT! GEQ 2 echo [WARN] Firewall setup was skipped or failed. Same-Wi-Fi PC AI may be blocked.

powershell -NoProfile -ExecutionPolicy Bypass -File tools\start_pc_ai.ps1 -Port %PC_PORT% -ExpectedVersion "v9-one-click-optimized"
if errorlevel 1 (
  echo [WARN] PC AI server did not start. Phone standalone AI and the APK are still usable.
) else (
  set "PC_AI_OK=1"
)

echo.
echo ================================================
echo CERTI:ON ONE-CLICK RESULT
echo ================================================
if "!BUILD_OK!"=="1" (echo [OK] APK: %CD%\%APK_OUTPUT%) else (echo [FAIL] APK build)
if "!INSTALL_OK!"=="1" (echo [OK] Phone app updated and opened) else (echo [INFO] Phone auto-update not completed)
if "!PC_AI_OK!"=="1" (
  if defined PC_URL echo [OK] PC Wi-Fi AI: !PC_URL!
  echo [OK] Ollama + CERTI:ON backend running
) else (
  echo [INFO] PC Wi-Fi AI not ready; phone standalone AI is unaffected
)
echo.
echo After phone update succeeds, you can unplug the C-to-C cable.
echo The PC AI address is already embedded into this APK when LAN IP detection succeeds.
echo Default PC model is 4B for fast startup; 8B/14B remain selectable in the app.
echo.
pause
exit /b 0

:build_release
set "BUILD_DEFINES=--dart-define=CERTI_DEFAULT_AI_MODEL=%DEFAULT_PC_MODEL%"
if defined API_DEFINE set "BUILD_DEFINES=!BUILD_DEFINES! !API_DEFINE!"
call flutter build apk --release --target-platform android-arm64 !BUILD_DEFINES!
exit /b !ERRORLEVEL!

:regenerate_android
set "TMP_MAIN=%TEMP%\certion_v9_main.dart"
set "TMP_PUB=%TEMP%\certion_v9_pubspec.yaml"
copy /Y lib\main.dart "!TMP_MAIN!" >nul
copy /Y pubspec.yaml "!TMP_PUB!" >nul
call flutter create --platforms=android --project-name certi_on --no-pub .
set "CREATE_EXIT=!ERRORLEVEL!"
copy /Y "!TMP_MAIN!" lib\main.dart >nul 2>nul
copy /Y "!TMP_PUB!" pubspec.yaml >nul 2>nul
del /Q "!TMP_MAIN!" "!TMP_PUB!" >nul 2>nul
if exist test rmdir /S /Q test >nul 2>nul
if exist .idea rmdir /S /Q .idea >nul 2>nul
del /Q *.iml >nul 2>nul
if not "!CREATE_EXIT!"=="0" exit /b !CREATE_EXIT!
echo [OK] Android wrapper generated for the current Flutter SDK.
exit /b 0

:fatal
echo.
echo ================================================
echo [FAILED] CERTI:ON one-click setup stopped.
echo Read the first ERROR/STOP line above.
echo ================================================
pause
exit /b 1
