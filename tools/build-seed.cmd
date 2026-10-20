@echo off
setlocal
set "root=%~dp0.."
if not exist "%root%\build" mkdir "%root%\build"
if not exist "%root%\build" (echo build-seed: cannot create build directory & exit /b 1)
if exist "%root%\build\seed.exe" del "%root%\build\seed.exe"
if exist "%root%\build\seed.exe" (echo build-seed: cannot remove old build\seed.exe & exit /b 1)
certutil -decodehex "%root%\bootstrap\seed.hex" "%root%\build\seed.exe" 4 >nul
if %errorlevel% neq 0 goto failed
for %%F in ("%root%\build\seed.exe") do if %%~zF equ 0 goto empty
exit /b 0
:empty
echo build-seed: bootstrap\seed.hex decodes to an empty file
goto cleanup
:failed
echo build-seed: certutil failed to decode bootstrap\seed.hex
:cleanup
if exist "%root%\build\seed.exe" del "%root%\build\seed.exe"
exit /b 1
