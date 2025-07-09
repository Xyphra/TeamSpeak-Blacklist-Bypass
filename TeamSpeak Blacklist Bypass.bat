@echo off
setlocal enabledelayedexpansion


openfiles >nul 2>&1
if %errorlevel% NEQ 0 (
    echo You must run this script as Administrator!
    pause
    exit /b
)

set "HOSTS_FILE=%windir%\System32\drivers\etc\hosts"

set "DOMAINS=blacklist2.teamspeak.com blacklist.teamspeak.com"

echo Blocking domains...

for %%D in (%DOMAINS%) do (
    echo Checking %%D...

    set "FOUND=0"
    for /f "usebackq delims=" %%L in ("%HOSTS_FILE%") do (
        set "LINE=%%L"

        set "LINE=!LINE: =!"
        if "!LINE!"=="0.0.0.0%%D" (
            set "FOUND=1"
        )
        if "!LINE!"=="0.0.0.0 %%D" (
            set "FOUND=1"
        )
    )

    if !FOUND! == 1 (
        echo Domain %%D is already blocked.
    ) else (
        echo. >> "%HOSTS_FILE%"
        echo 0.0.0.0 %%D >> "%HOSTS_FILE%"
        echo Domain %%D has been successfully blocked.
    )
)

echo.
echo All done!
pause
