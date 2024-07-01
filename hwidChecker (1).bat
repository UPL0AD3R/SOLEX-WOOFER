@echo off
title HWID Checker
echo **********************************
call :SetColor 1F  :: Call function to set color to blue (1F)
echo **********************************
:start
cls
echo Disk Drive
wmic diskdrive get model, serialnumber
echo CPU
wmic cpu get serialnumber
echo BIOS
wmic bios get serialnumber
echo Motherboard
wmic baseboard get serialnumber
echo GPU
wmic path win32_videocontroller get caption, pnpdeviceid
echo smBIOS UUID
wmic path win32_computersystemproduct get uuid

rem Get MAC addresses and filter out disconnected adapters
set "mac_found="
for /f "tokens=1,2 delims= " %%A in ('getmac /NH /FO TABLE') do (
    if "%%B" NEQ "Disconnected" (
        echo MAC Address: %%A %%B
        set "mac_found=true"
    )
)

rem If no MAC address found, display a message
if not defined mac_found (
    echo MAC Address: Not available (no connected adapters found)
)

echo.
echo Press any key to get your hardware serials again.
pause >nul
goto start

:SetColor
echo off
set "ansi=%~1"
powershell -command "$Host.UI.RawUI.ForegroundColor = [System.ConsoleColor]::Cyan"
exit /b
