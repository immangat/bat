@echo off

NET SESSION >NUL
IF %ERRORLEVEL% NEQ 0 GOTO ELEVATE >NUL
goto :start

:ELEVATE
CD /d %~dp0
MSHTA "javascript: var shell = new ActiveXObject('shell.application'); shell.ShellExecute('%~nx0', '', '', 'runas', 1);close();" >NUL
EXIT

:start
echo ==============================
echo === FNSRWR v1 by DannyVoid ===
echo ==============================
echo.

echo.
echo Releasing and Renewing...
ipconfig /release >NUL
ipconfig /renew >NUL

echo Resetting Arp Cache...
netsh int ip delete arpcache >NUL

echo Resetting Local IP...
netsh int ip reset >NUL

echo Resetting Winsock...
netsh winsock reset >NUL

echo Resetting Network Adapter...
for /F "skip=3 tokens=1,2,3* delims= " %%G in ('netsh interface show interface') DO (
    IF "%%H"=="Connected" netsh interface set interface "%%J" disabled
) >NUL

for /F "skip=3 tokens=1,2,3* delims= " %%G in ('netsh interface show interface') DO (
    IF "%%H"=="Disconnected" netsh interface set interface "%%J" enabled
) >NUL
goto :done

:done
echo.
echo Complete! Your connection should continue as normal.
pause
goto :stop

:stop
exit
