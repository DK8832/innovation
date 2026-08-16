@echo off
chcp 65001 >nul
title CERTI:ON - Publish 24 GitHub Version Assets
cd /d "%~dp0"
echo.
echo ======================================================
echo   CERTI:ON 24개 버전 GitHub Release 일괄 업로드
echo ======================================================
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\PUBLISH_ALL_VERSION_ASSETS.ps1" "%~dp0"
set ERR=%ERRORLEVEL%
echo.
if not "%ERR%"=="0" (
  echo [ERROR] 업로드 중 오류가 발생했습니다. 위 메시지를 확인하세요.
  pause
  exit /b %ERR%
)
echo [SUCCESS] 모든 버전 업로드 완료.
pause
