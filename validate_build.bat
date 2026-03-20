@echo off
setlocal EnableExtensions

cd /d "%~dp0"

echo ========================================
echo Validacao de compilacao - ProjetoVendas
echo ========================================

if not exist "ProjetoVendas.dproj" (
  echo [ERRO] ProjetoVendas.dproj nao encontrado.
  exit /b 1
)

if not exist "bin" mkdir "bin"
if not exist "bin\Win32" mkdir "bin\Win32"
if not exist "bin\Win32\Debug" mkdir "bin\Win32\Debug"
if not exist "bin\Win32\Release" mkdir "bin\Win32\Release"

set "DCC_CMD="

if defined BDS (
  if exist "%BDS%\bin\rsvars.bat" (
    call "%BDS%\bin\rsvars.bat"
  )
)

if exist "%ProgramFiles(x86)%\Embarcadero\Studio\23.0\bin\rsvars.bat" call "%ProgramFiles(x86)%\Embarcadero\Studio\23.0\bin\rsvars.bat"
if exist "%ProgramFiles(x86)%\Embarcadero\Studio\22.0\bin\rsvars.bat" call "%ProgramFiles(x86)%\Embarcadero\Studio\22.0\bin\rsvars.bat"
if exist "%ProgramFiles(x86)%\Embarcadero\Studio\21.0\bin\rsvars.bat" call "%ProgramFiles(x86)%\Embarcadero\Studio\21.0\bin\rsvars.bat"
if exist "%ProgramFiles(x86)%\Embarcadero\Studio\20.0\bin\rsvars.bat" call "%ProgramFiles(x86)%\Embarcadero\Studio\20.0\bin\rsvars.bat"

where dcc32 >nul 2>&1
if %errorlevel%==0 (
  set "DCC_CMD=dcc32"
)

if "%DCC_CMD%"=="" (
  if defined BDS if exist "%BDS%\bin\dcc32.exe" set "DCC_CMD=%BDS%\bin\dcc32.exe"
)

if "%DCC_CMD%"=="" (
  echo [ERRO] Nao foi encontrado o compilador dcc32.
  echo        Abra o Prompt do RAD Studio ou configure o ambiente com rsvars.bat.
  exit /b 1
)

echo.
echo [1/2] Build Debug Win32...
"%DCC_CMD%" -B -Q -DDEBUG -E"bin\Win32\Debug" -N"bin\Win32\Debug" -U"src;src\domain;src\application;src\infrastructure;src\presentation" "ProjetoVendas.dpr" > build_debug.log 2>&1
if errorlevel 1 (
  echo [ERRO] Falha na compilacao Debug. Veja build_debug.log
  exit /b 1
)

echo.
echo [2/2] Build Release Win32...
"%DCC_CMD%" -B -Q -DRELEASE -$O+ -E"bin\Win32\Release" -N"bin\Win32\Release" -U"src;src\domain;src\application;src\infrastructure;src\presentation" "ProjetoVendas.dpr" > build_release.log 2>&1
if errorlevel 1 (
  echo [ERRO] Falha na compilacao Release. Veja build_release.log
  exit /b 1
)

echo.
echo [OK] Compilacao concluida com sucesso.
exit /b 0
