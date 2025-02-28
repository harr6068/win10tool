@echo off
setlocal enabledelayedexpansion

:: Check for administrative privileges
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process -FilePath '%~f0' -ArgumentList '-runElevated' -Verb RunAs"
    exit /b
)

if "%1"=="-runElevated" (
    echo Please wait...
    goto :run_script
)

:run_script
:: Function to detect the drive letter where setup.exe is located
for %%i in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%i:\setup.exe (
        set "iso_drive=%%i:"
        echo Detected Drive: %%i:
        goto :drive_found
    )
)
echo Mount ISO file now.
pause
exit /b

:drive_found
:: Run setup.exe 
echo Launching Setup
start "" "%iso_drive%\setup.exe" /dynamicupdate disable /auto upgrade /bitlocker alwayssuspend /compat ignorewarning /DiagnosticPrompt enable /imageindex 1 /telemetry disable

pause
