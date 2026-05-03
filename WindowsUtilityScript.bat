@echo off
title SpecterLogic - System Repair Toolkit

:: ── Elevate to administrator if needed ─────────────────────
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: ── Main Menu Loop ─────────────────────────────────────────
:menu
cls
echo  .d8888b.                             888                    888                       d8b          
echo d88P  Y88b                            888                    888                       Y8P          
echo Y88b.                                 888                    888                                    
echo  "Y888b.   88888b.   .d88b.   .d8888b 888888 .d88b.  888d888 888      .d88b.   .d88b.  888  .d8888b 
echo     "Y88b. 888 "88b d8P  Y8b d88P"    888   d8P  Y8b 888P"   888     d88""88b d88P"88b 888 d88P"    
echo       "888 888  888 88888888 888      888   88888888 888     888     888  888 888  888 888 888      
echo Y88b  d88P 888 d88P Y8b.     Y88b.    Y88b. Y8b.     888     888     Y88..88P Y88b 888 888 Y88b.    
echo  "Y8888P"  88888P"   "Y8888   "Y8888P  "Y888 "Y8888  888     88888888 "Y88P"   "Y88888 888  "Y8888P 
echo            888                                                                     888              
echo            888                                                                Y8b d88P              
echo            888                                                                 "Y88P"               
echo.
echo 		Windows System Repair ^& Maintenance Toolkit
echo ------------------------------------------------------------
echo   [1] File Permission ^& Locked File Removal
echo   [2] Windows Update Repair
echo   [3] Network Reset ^& Repair
echo   [4] System Cleanup ^& Disk Space Free-up
echo   [5] Kill Heavy Processes ^& Free RAM
echo   [6] Quick Full Repair (One-click)
echo   [7] Exit
echo ------------------------------------------------------------
set /p "opt=Choose an option (1-7): "
if "%opt%"=="1" (call :filefix & goto :menu)
if "%opt%"=="2" (call :uprepair & goto :menu)
if "%opt%"=="3" (call :netrepair & goto :menu)
if "%opt%"=="4" (call :cleanup & goto :menu)
if "%opt%"=="5" (call :killproc & goto :menu)
if "%opt%"=="6" (call :fullfix & goto :menu)
if "%opt%"=="7" exit /b
goto :menu

:: ==============================================================
:: 1. FILE PERMISSION & LOCKED FILE REMOVAL
:: ==============================================================
:filefix
cls
echo === File Permission ^& Locked File Removal ===
set /p "fpath=Enter full path to file or folder: "
if not defined fpath goto :filefix
if not exist "%fpath%" (
    echo Invalid path.
    pause >nul
    exit /b
)
echo.
echo Choose action:
echo   [1] Take ownership and grant full control
echo   [2] Force delete the file/folder
echo   [3] Both (take ownership then force delete)
set /p "fact=Select (1-3): "
if "%fact%"=="1" goto :do_own
if "%fact%"=="2" goto :do_del
if "%fact%"=="3" goto :do_both
goto :filefix

:do_own
echo Taking ownership...
takeown /F "%fpath%" /R /D Y >nul 2>&1
if errorlevel 1 (
    echo Failed to take ownership.
) else (
    icacls "%fpath%" /grant "%USERNAME%":F /T /C /Q >nul 2>&1
    echo Ownership and full control granted.
)
pause >nul
exit /b

:do_del
echo Deleting...
if exist "%fpath%\" (
    rmdir /S /Q "%fpath%" >nul 2>&1
) else (
    del /F /Q "%fpath%" >nul 2>&1
)
if exist "%fpath%" (
    echo Deletion failed. The item may be in use.
) else (
    echo Deleted successfully.
)
pause >nul
exit /b

:do_both
call :do_own
if exist "%fpath%" call :do_del
exit /b

:: ==============================================================
:: 2. WINDOWS UPDATE REPAIR
:: ==============================================================
:uprepair
cls
echo === Windows Update Repair ===
echo This will stop services, rename SoftwareDistribution/Catroot2, and restart them.
set /p "uconfirm=Proceed? (y/n): "
if /i not "%uconfirm%"=="y" exit /b
echo Stopping services...
sc stop wuauserv >nul 2>&1
sc stop bits >nul 2>&1
sc stop cryptSvc >nul 2>&1
sc stop msiserver >nul 2>&1
timeout /t 3 /nobreak >nul
echo Renaming update folders...
if exist "%SystemRoot%\SoftwareDistribution" (
    ren "%SystemRoot%\SoftwareDistribution" "SoftwareDistribution.old" >nul 2>&1
)
if exist "%SystemRoot%\System32\Catroot2" (
    ren "%SystemRoot%\System32\Catroot2" "Catroot2.old" >nul 2>&1
)
echo Restarting services...
sc start wuauserv >nul 2>&1
sc start bits >nul 2>&1
sc start cryptSvc >nul 2>&1
sc start msiserver >nul 2>&1
echo Done. A reboot is recommended.
pause >nul
exit /b

:: ==============================================================
:: 3. NETWORK RESET & REPAIR
:: ==============================================================
:netrepair
cls
echo === Network Reset ^& Repair ===
echo   [1] Full network reset (IP, Winsock, DNS flush)
echo   [2] Reconnect Wi-Fi
echo   [3] Flush DNS only
echo   [4] Back
set /p "nchoice=Select (1-4): "
if "%nchoice%"=="1" call :fullnet
if "%nchoice%"=="2" call :wificonn
if "%nchoice%"=="3" call :dnsflush
exit /b

:fullnet
echo Resetting TCP/IP, Winsock, DNS...
ipconfig /release >nul
ipconfig /renew >nul
ipconfig /flushdns >nul
netsh int ip reset >nul
netsh winsock reset >nul
echo Network reset complete. Reboot recommended.
pause >nul
exit /b

:wificonn
echo Reconnecting Wi-Fi...
for /f "tokens=2 delims=:" %%a in ('netsh wlan show interfaces ^| find "SSID" ^| findstr /v "BSSID"') do set "ssid=%%a"
set "ssid=%ssid:~1%"
if defined ssid (
    netsh wlan disconnect >nul 2>&1
    timeout /t 2 /nobreak >nul
    netsh wlan connect name="%ssid%" >nul 2>&1
    echo Wi-Fi reconnected to %ssid%.
) else (
    echo No active Wi-Fi connection found.
)
pause >nul
exit /b

:dnsflush
ipconfig /flushdns >nul
echo DNS cache cleared.
pause >nul
exit /b

:: ==============================================================
:: 4. SYSTEM CLEANUP & DISK SPACE FREE-UP
:: ==============================================================
:cleanup
cls
echo === System Cleanup ^& Disk Space Free-up ===
echo   1. Clean User Temp files
echo   2. Clean System Temp files (C:\Windows\Temp)
echo   3. Clean Prefetch
echo   4. Clean Browser Cache (Chrome + Edge)
echo   5. Empty Recycle Bin
echo   6. Clean All (above items)
echo   7. Back
set /p "clch=Select (1-7): "
if "%clch%"=="1" call :user_temp
if "%clch%"=="2" call :sys_temp
if "%clch%"=="3" call :prefetch
if "%clch%"=="4" call :browsercache
if "%clch%"=="5" call :emptybin
if "%clch%"=="6" (
    call :user_temp
    call :sys_temp
    call :prefetch
    call :browsercache
    call :emptybin
)
exit /b

:user_temp
echo Cleaning User Temp: %TEMP%
del /F /S /Q "%TEMP%\*" >nul 2>&1
rmdir /S /Q "%TEMP%" >nul 2>&1
echo Done.
exit /b

:sys_temp
echo Cleaning System Temp: %SystemRoot%\Temp
del /F /S /Q "%SystemRoot%\Temp\*" >nul 2>&1
rmdir /S /Q "%SystemRoot%\Temp" >nul 2>&1
echo Done.
exit /b

:prefetch
echo Cleaning Prefetch: %SystemRoot%\Prefetch
del /F /S /Q "%SystemRoot%\Prefetch\*" >nul 2>&1
echo Done.
exit /b

:browsercache
echo Cleaning Chrome and Edge cache...
for %%p in (
    "%LocalAppData%\Google\Chrome\User Data\*\Cache"
    "%LocalAppData%\Google\Chrome\User Data\*\Code Cache"
    "%LocalAppData%\Microsoft\Edge\User Data\*\Cache"
    "%LocalAppData%\Microsoft\Edge\User Data\*\Code Cache"
) do (
    if exist "%%p" (
        del /F /S /Q "%%p\*" >nul 2>&1
        rmdir /S /Q "%%p" >nul 2>&1
    )
)
echo Done.
exit /b

:emptybin
echo Emptying Recycle Bin...
powershell -Command "Clear-RecycleBin -Force" >nul 2>&1
if errorlevel 1 ( echo Failed. ) else ( echo Done. )
exit /b

:: ==============================================================
:: 5. KILL HEAVY PROCESSES & FREE RAM
:: ==============================================================
:killproc
cls
echo === Memory ^& Heavy Process Management ===
echo   [1] Kill common heavy apps (Chrome, Edge, VS Code)
echo   [2] List top RAM hogs (PowerShell) and kill selected
echo   [3] Back
set /p "kchoice=Select (1-3): "
if "%kchoice%"=="1" (
    echo Killing Chrome, Edge, VS Code...
    taskkill /F /IM chrome.exe >nul 2>&1
    taskkill /F /IM msedge.exe >nul 2>&1
    taskkill /F /IM code.exe >nul 2>&1
    echo Done.
)
if "%kchoice%"=="2" (
    echo Launching PowerShell RAM viewer...
    powershell -Command "$p=Get-Process|Sort-Object WorkingSet64 -Descending|Select-Object -First 10; $i=1; $p|%%{Write-Host \"[$i] $($_.ProcessName) (ID:$($_.Id)) - $([math]::Round($_.WorkingSet64/1MB,1)) MB\"; $i++}; $k=Read-Host 'Enter numbers (comma separated, 0 to cancel)'; if($k -ne '0'){$idx=$k -split ','|%%{[int]$_.Trim()}; foreach($i in $idx){if($i -gt 0 -and $i -le $p.Count){Stop-Process -Id $p[$i-1].Id -Force}}}"
)
pause >nul
exit /b

:: ==============================================================
:: 6. QUICK FULL REPAIR (ONE-CLICK)
:: ==============================================================
:fullfix
cls
echo === Quick Full Repair ===
echo This will run: Windows Update repair, network reset, temp/cache/prefetch cleanup,
echo empty recycle bin, and kill heavy apps.
set /p "qconfirm=Proceed? (y/n): "
if /i not "%qconfirm%"=="y" exit /b
call :uprepair
call :fullnet
call :user_temp
call :sys_temp
call :prefetch
call :browsercache
call :emptybin
echo Killing heavy apps...
taskkill /F /IM chrome.exe >nul 2>&1
taskkill /F /IM msedge.exe >nul 2>&1
taskkill /F /IM code.exe >nul 2>&1
echo Full repair completed. A reboot is strongly recommended.
pause >nul
exit /b