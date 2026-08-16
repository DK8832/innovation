@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"

set "REPO=DK8832/innovation"
set "ARCHIVES=%~dp0archives"
set "TEST_ONLY=0"
if /I "%~1"=="--test-only" set "TEST_ONLY=1"
set /a COUNT=0
set /a OK=0
set "FAILMSG="
set "GH="

cls
echo ==============================================================
echo   CERTI:ON - DK8832/innovation GitHub Release Asset Uploader
echo ==============================================================
echo.
if "%TEST_ONLY%"=="1" (
  echo MODE: PREFLIGHT TEST ONLY - no files will be uploaded.
) else (
  echo MODE: REAL UPLOAD - 24 source ZIP files will be uploaded.
)
echo.

call :find_gh
if errorlevel 1 goto :fail

echo [OK] GitHub CLI: "%GH%"

echo [1/4] Checking GitHub authentication...
"%GH%" auth status --hostname github.com >nul 2>&1
if errorlevel 1 (
  echo [AUTH] Browser login is required once.
  "%GH%" auth login --hostname github.com --git-protocol https --web
  if errorlevel 1 (
    set "FAILMSG=GitHub login failed."
    goto :fail
  )
)
echo [OK] GitHub authentication is ready.
echo.

echo [2/4] Checking repository access...
"%GH%" repo view "%REPO%" >nul 2>&1
if errorlevel 1 (
  set "FAILMSG=Cannot access DK8832/innovation with the current GitHub account."
  goto :fail
)
echo [OK] Repository access confirmed.
echo.

echo [3/4] Checking all 24 ZIP files and release tags...
call :upload "v0.1.0"  "v01__certi_on_ogq_ultimate__SOURCE.zip" || goto :fail
call :upload "v0.2.0"  "v02__certi_on_ogq__SOURCE.zip" || goto :fail
call :upload "v0.3.0"  "v03__certi_on_ogq_ultimate1__SOURCE.zip" || goto :fail
call :upload "v0.4.0"  "v04__certi_on_ogq_ultimate2__SOURCE.zip" || goto :fail
call :upload "v0.5.0"  "v05__certi_on_ogq_ultimate3__SOURCE.zip" || goto :fail
call :upload "v0.6.0"  "v06__certi_on_ogq_ultimate4__SOURCE.zip" || goto :fail
call :upload "v0.7.0"  "v07__z_real_final_final_final_certi_on_ogq_ai_fixed__SOURCE.zip" || goto :fail
call :upload "v0.8.0"  "v08__CERTI_ON_OGQ_FULL_FIXED__SOURCE.zip" || goto :fail
call :upload "v0.9.0"  "v09__CERTI_ON_OGQ_FULL_FIXED_V2__SOURCE.zip" || goto :fail
call :upload "v0.10.0" "v10__CERTI_ON_OGQ_LOCAL_AI_SMART__SOURCE.zip" || goto :fail
call :upload "v0.11.0" "v11__CERTI_ON_OGQ_LOCAL_AI_SMART_V2__SOURCE.zip" || goto :fail
call :upload "v0.12.0" "v12__CERTI_ON_OGQ_ORIGINAL_LOCAL_QWEN14B__SOURCE.zip" || goto :fail
call :upload "v0.13.0" "v13__CERTI_ON_OGQ_QWEN14B_SMART_CHAT_FIXED__SOURCE.zip" || goto :fail
call :upload "v0.14.0" "v14__CERTI_ON_OGQ_QWEN14B_SMART_CHAT_FIXED_V2__SOURCE.zip" || goto :fail
call :upload "v0.15.0" "v15__FINAL_ULTIMATE_CERTI_ON_OGQ_AI_MODEL_SELECTOR_NO_TIMEOUT__SOURCE.zip" || goto :fail
call :upload "v0.16.0" "v16__FINAL_FINAL_ULTIMATE_CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED__SOURCE.zip" || goto :fail
call :upload "v0.17.0" "v17__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V2__SOURCE.zip" || goto :fail
call :upload "v0.18.0" "v18__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V3__SOURCE.zip" || goto :fail
call :upload "v0.19.0" "v19__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V4__SOURCE.zip" || goto :fail
call :upload "v0.20.0" "v20__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V5__SOURCE.zip" || goto :fail
call :upload "v0.21.0" "v21__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V6__SOURCE.zip" || goto :fail
call :upload "v0.22.0" "v22__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V7__SOURCE.zip" || goto :fail
call :upload "v0.23.0" "v23__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V8__SOURCE.zip" || goto :fail
call :upload "v1.0.0"  "v24__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V9__SOURCE.zip" || goto :fail

echo.
if "%TEST_ONLY%"=="1" (
  echo ==============================================================
  echo   PREFLIGHT PASSED: !OK!/24 files and releases are ready.
  echo   Nothing was uploaded in test mode.
  echo ==============================================================
) else (
  echo ==============================================================
  echo   SUCCESS: !OK!/24 release assets uploaded and verified.
  echo ==============================================================
  echo.
  echo Opening GitHub Releases...
  start "" "https://github.com/DK8832/innovation/releases"
)
echo.
if defined CI exit /b 0
echo Press any key to finish.
pause >nul
exit /b 0

:find_gh
where gh.exe >nul 2>&1
if not errorlevel 1 (
  for /f "delims=" %%G in ('where gh.exe 2^>nul') do if not defined GH set "GH=%%G"
)
if defined GH exit /b 0

if exist "%ProgramFiles%\GitHub CLI\gh.exe" set "GH=%ProgramFiles%\GitHub CLI\gh.exe"
if defined GH exit /b 0
if exist "%ProgramFiles(x86)%\GitHub CLI\gh.exe" set "GH=%ProgramFiles(x86)%\GitHub CLI\gh.exe"
if defined GH exit /b 0
if exist "%LOCALAPPDATA%\Programs\GitHub CLI\gh.exe" set "GH=%LOCALAPPDATA%\Programs\GitHub CLI\gh.exe"
if defined GH exit /b 0

echo [SETUP] GitHub CLI was not found. Trying automatic install with winget...
where winget.exe >nul 2>&1
if errorlevel 1 (
  set "FAILMSG=GitHub CLI is missing and winget is not available. Install GitHub CLI and run again."
  exit /b 1
)
winget install --id GitHub.cli -e --accept-package-agreements --accept-source-agreements
if errorlevel 1 (
  set "FAILMSG=Automatic GitHub CLI installation failed."
  exit /b 1
)

if exist "%ProgramFiles%\GitHub CLI\gh.exe" set "GH=%ProgramFiles%\GitHub CLI\gh.exe"
if not defined GH if exist "%ProgramFiles(x86)%\GitHub CLI\gh.exe" set "GH=%ProgramFiles(x86)%\GitHub CLI\gh.exe"
if not defined GH if exist "%LOCALAPPDATA%\Programs\GitHub CLI\gh.exe" set "GH=%LOCALAPPDATA%\Programs\GitHub CLI\gh.exe"
if not defined GH (
  set "FAILMSG=GitHub CLI installed, but gh.exe could not be located. Reopen this uploader once."
  exit /b 1
)
exit /b 0

:upload
set /a COUNT+=1
set "TAG=%~1"
set "FILE=%~2"
set "FULL=%ARCHIVES%\%~2"

echo [!COUNT!/24] !TAG!  -  !FILE!

if not exist "!FULL!" (
  set "FAILMSG=Missing ZIP: !FULL!"
  exit /b 1
)

for %%Z in ("!FULL!") do if %%~zZ LSS 1000 (
  set "FAILMSG=ZIP is unexpectedly small or empty: !FILE!"
  exit /b 1
)

"%GH%" release view "!TAG!" --repo "%REPO%" >nul 2>&1
if errorlevel 1 (
  set "FAILMSG=GitHub Release not found: !TAG!"
  exit /b 1
)

if "%TEST_ONLY%"=="1" (
  set /a OK+=1
  echo     [PASS] local ZIP and GitHub Release are present.
  exit /b 0
)

echo     Uploading...
"%GH%" release upload "!TAG!" "!FULL!" --repo "%REPO%" --clobber
if errorlevel 1 (
  set "FAILMSG=Upload failed: !TAG! / !FILE!"
  exit /b 1
)

set "CHECK=%TEMP%\certion_release_asset_check_!RANDOM!_!RANDOM!.json"
"%GH%" release view "!TAG!" --repo "%REPO%" --json assets > "!CHECK!" 2>nul
if errorlevel 1 (
  del /q "!CHECK!" >nul 2>&1
  set "FAILMSG=Upload returned success, but release verification failed: !TAG!"
  exit /b 1
)
findstr /I /C:"!FILE!" "!CHECK!" >nul 2>&1
set "VERIFY_RC=!ERRORLEVEL!"
del /q "!CHECK!" >nul 2>&1
if not "!VERIFY_RC!"=="0" (
  set "FAILMSG=Uploaded asset was not found in GitHub Release: !TAG! / !FILE!"
  exit /b 1
)

set /a OK+=1
echo     [PASS] uploaded and verified.
exit /b 0

:fail
echo.
echo ==============================================================
echo   ERROR
echo ==============================================================
if defined FAILMSG echo !FAILMSG!
echo.
echo The window stays open so you can read the error above.
echo Fix the issue and run START_UPLOAD.bat again.
echo.
if defined CI exit /b 1
echo Press any key to finish.
pause >nul
exit /b 1
