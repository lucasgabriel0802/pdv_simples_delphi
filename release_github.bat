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
  echo [ERRO] Versao nao informada.
  echo Uso: release_github.bat 0.1.0
  exit /b 1
)

where gh >nul 2>&1
if errorlevel 1 (
  echo [ERRO] GitHub CLI gh nao encontrado.
  echo Instale: https://cli.github.com/
  exit /b 1
)

call package_release.bat %VERSION%
if errorlevel 1 exit /b 1

set "ZIP_FILE=dist\ProjetoVendas-v%VERSION%-win32.zip"
set "HASH_FILE=dist\ProjetoVendas-v%VERSION%-win32.sha256.txt"

if not exist "%ZIP_FILE%" (
  echo [ERRO] Artefato ZIP nao encontrado: %ZIP_FILE%
  exit /b 1
)

set "NOTES_FILE=RELEASE_NOTES_TEMPLATE.md"
if not exist "%NOTES_FILE%" (
  echo ## Release v%VERSION%> "%NOTES_FILE%"
)

git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
  echo [ERRO] Este diretorio nao esta em um repositorio git.
  exit /b 1
)

git rev-parse -q --verify "refs/tags/v%VERSION%" >nul 2>&1
if not errorlevel 1 (
  echo [ERRO] A tag v%VERSION% ja existe localmente.
  exit /b 1
)

git ls-remote --exit-code --tags origin "refs/tags/v%VERSION%" >nul 2>&1
if not errorlevel 1 (
  echo [ERRO] A tag v%VERSION% ja existe no remoto.
  exit /b 1
)

git tag -a "v%VERSION%" -m "Release v%VERSION%"
if errorlevel 1 (
  echo [ERRO] Falha ao criar a tag local v%VERSION%.
  exit /b 1
)

gh release create "v%VERSION%" "%ZIP_FILE%" "%HASH_FILE%" --title "ProjetoVendas v%VERSION%" --notes-file "%NOTES_FILE%"
if errorlevel 1 (
  echo [ERRO] Falha ao criar release no GitHub.
  exit /b 1
)

> VERSION echo %VERSION%
if errorlevel 1 (
  echo [ERRO] Release criada, mas nao foi possivel atualizar o arquivo VERSION.
  exit /b 1
)

echo [OK] Release publicada: v%VERSION%
exit /b 0
