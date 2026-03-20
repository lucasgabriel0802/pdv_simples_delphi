@echo off
setlocal EnableExtensions

cd /d "%~dp0"

set "VERSION=%~1"
if "%VERSION%"=="" (
  if exist VERSION (
    set /p VERSION=<VERSION
  )
)

if "%VERSION%"=="" (
  echo [ERRO] Versao nao informada e arquivo VERSION ausente.
  echo Uso: package_release.bat 0.1.0
  exit /b 1
)

echo ========================================
echo Empacotamento de release v%VERSION%
echo ========================================

call validate_build.bat
if errorlevel 1 exit /b 1

set "RELEASE_DIR=dist\ProjetoVendas-v%VERSION%-win32"
set "ZIP_FILE=dist\ProjetoVendas-v%VERSION%-win32.zip"

if exist dist rmdir /s /q dist
mkdir "%RELEASE_DIR%"

if not exist "bin\Win32\Release\ProjetoVendas.exe" (
  echo [ERRO] Executavel de release nao encontrado em bin\Win32\Release\ProjetoVendas.exe
  exit /b 1
)

copy /y "bin\Win32\Release\ProjetoVendas.exe" "%RELEASE_DIR%\ProjetoVendas.exe" >nul

if exist "database.ini" copy /y "database.ini" "%RELEASE_DIR%\database.ini" >nul
if exist "RELEASE_NOTES_TEMPLATE.md" copy /y "RELEASE_NOTES_TEMPLATE.md" "%RELEASE_DIR%\RELEASE_NOTES_TEMPLATE.md" >nul
if exist "docs\scripts\create_database.sql" (
  mkdir "%RELEASE_DIR%\docs\scripts" >nul 2>&1
  copy /y "docs\scripts\create_database.sql" "%RELEASE_DIR%\docs\scripts\create_database.sql" >nul
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "Compress-Archive -Path '%RELEASE_DIR%\*' -DestinationPath '%ZIP_FILE%' -Force"
if errorlevel 1 (
  echo [ERRO] Falha ao gerar ZIP de release.
  exit /b 1
)

certutil -hashfile "%ZIP_FILE%" SHA256 > "dist\ProjetoVendas-v%VERSION%-win32.sha256.txt"

echo [OK] Pacote gerado:
echo      %ZIP_FILE%
echo      dist\ProjetoVendas-v%VERSION%-win32.sha256.txt
exit /b 0
