@echo off
setlocal EnableExtensions

cd /d "%~dp0"

set "REPO_URL=%~1"
if "%REPO_URL%"=="" set "REPO_URL=https://github.com/lucasgabriel0802/pdv_simples_delphi.git"
set "DEFAULT_BRANCH=main"

echo ========================================
echo Setup automatico do repositorio GitHub
echo ========================================
echo Repo: %REPO_URL%

git --version >nul 2>&1
if errorlevel 1 (
  echo [ERRO] Git nao encontrado no PATH.
  exit /b 1
)

if not exist ".git" (
  echo [INFO] Inicializando repositorio git local...
  git init
  if errorlevel 1 (
    echo [ERRO] Falha ao inicializar git.
    exit /b 1
  )
)

git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
  echo [ERRO] Diretorio atual nao e um repositorio git valido.
  exit /b 1
)

git branch -M %DEFAULT_BRANCH%

git remote get-url origin >nul 2>&1
if errorlevel 1 (
  echo [INFO] Configurando remote origin...
  git remote add origin %REPO_URL%
) else (
  echo [INFO] Atualizando remote origin...
  git remote set-url origin %REPO_URL%
)

for /f "delims=" %%a in ('git config --get user.name') do set GIT_USER=%%a
if "%GIT_USER%"=="" (
  echo [ERRO] Git user.name nao configurado.
  echo Execute: git config --global user.name "Seu Nome"
  exit /b 1
)

for /f "delims=" %%a in ('git config --get user.email') do set GIT_EMAIL=%%a
if "%GIT_EMAIL%"=="" (
  echo [ERRO] Git user.email nao configurado.
  echo Execute: git config --global user.email "seu@email.com"
  exit /b 1
)

git add .
git diff --cached --quiet
if errorlevel 1 (
  git commit -m "chore: preparar projeto para build e release"
  if errorlevel 1 (
    echo [ERRO] Falha ao criar commit.
    exit /b 1
  )
) else (
  echo [INFO] Sem alteracoes para commit.
)

echo [INFO] Tentando enviar para %DEFAULT_BRANCH%...
git push -u origin %DEFAULT_BRANCH%
if errorlevel 1 (
  echo [ALERTA] Nao foi possivel fazer push automatico.
  echo Verifique autenticacao/permissão no GitHub e execute manualmente:
  echo   git push -u origin %DEFAULT_BRANCH%
  exit /b 1
)

echo [OK] Repositorio configurado e enviado ao GitHub com sucesso.
exit /b 0
