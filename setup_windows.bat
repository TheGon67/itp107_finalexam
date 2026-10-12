@echo off
cd /d "%~dp0"
where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter is missing from PATH. Follow README.md first.
  pause
  exit /b 1
)
call dart tool\setup.dart
if errorlevel 1 (
  echo Setup stopped. Read the error above.
  pause
  exit /b 1
)
pause
