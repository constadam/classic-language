@echo off
setlocal
set "root=%~dp0.."
if not exist "%root%\build\seed.exe" (echo build-hex1: build\seed.exe is missing, run tools\build-seed.cmd & exit /b 1)
if exist "%root%\build\hex1.exe" del "%root%\build\hex1.exe"
if exist "%root%\build\hex1.exe" (echo build-hex1: cannot remove old build\hex1.exe & exit /b 1)
if exist "%root%\build\hex1.certutil" del "%root%\build\hex1.certutil"
"%root%\build\seed.exe" "%root%\bootstrap\hex1.hex" "%root%\build\hex1.exe"
if %errorlevel% neq 0 goto seedfailed
certutil -decodehex "%root%\bootstrap\hex1.hex" "%root%\build\hex1.certutil" 4 >nul
if %errorlevel% neq 0 goto certutilfailed
fc /b "%root%\build\hex1.exe" "%root%\build\hex1.certutil" >nul
if %errorlevel% neq 0 goto differs
del "%root%\build\hex1.certutil"
for %%F in ("%root%\build\hex1.exe") do if %%~zF equ 0 goto empty
exit /b 0
:seedfailed
echo build-hex1: seed.exe rejected bootstrap\hex1.hex
goto cleanup
:certutilfailed
echo build-hex1: certutil rejected bootstrap\hex1.hex
goto cleanup
:differs
echo build-hex1: seed.exe and certutil produced different bytes
goto cleanup
:empty
echo build-hex1: bootstrap\hex1.hex decodes to an empty file
:cleanup
if exist "%root%\build\hex1.exe" del "%root%\build\hex1.exe"
if exist "%root%\build\hex1.certutil" del "%root%\build\hex1.certutil"
exit /b 1
