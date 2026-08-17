@echo off
setlocal

cd /d "%~dp0"

if not exist ".venv" (
  echo [1/3] Creating virtual environment...
  python -m venv .venv
)

echo [2/3] Installing dependencies...
".venv\Scripts\python.exe" -m pip install -q --disable-pip-version-check -r backend\requirements.txt

echo [3/3] Starting server...
start "exam-calendar-server" ".venv\Scripts\python.exe" -X utf8 backend\main.py
ping -n 3 127.0.0.1 >nul
start "" http://127.0.0.1:8000

echo Server is running in a separate window. Close that window to stop it.
endlocal
