@echo off

rem For convenience, add a a wrapper script at cmd.exe's home dir, so that user can run it once cmd.exe launched.
rem the wrapper script can be named the same for consistency,  %HOMEDRIVE%%HOMEPATH%\siteenv.cmd which has
rem just one line
rem    call "C:\users\%username%\sitebase\github\site-spec\bat\siteenv.cmd"
rem
rem note; cmd.exe's home dir, which is %HOMEDRIVE%%HOMEPATH%, not %USERPROFILE%.
rem %USERPROFILE% is always C:\Users\%USERNAME%, but sometimes, inside company, home dir is H:\. therefore
rem %HOMEDRIVE%%HOMEPATH% is more reliable
rem 
rem Linking could have worked but it requires admin access, therefore, may not work in company env. 
rem    run cmd.exe as administrator
rem    cd C:\Users\william
rem    C:\Users\william>mklink siteenv.cmd sitebase\github\site-spec\siteenv.cmd
rem    symbolic link created for siteenv.cmd <<===>> sitebase\github\tpsup\env\siteenv.cmd

rem don't use setx. setx will permanently change the setting
rem set "SITESPEC=C:\users\%username%\sitebase\github\site-spec"
rem set "SITEBASE=C:\users\%username%\sitebase"
set "SITECMD=%~dp0"
echo SITECMD=%SITECMD%

call :REL2ABS "%SITECMD%\.."
set "SITESPEC=%RETVAL%"
echo SITESPEC=%SITESPEC%

call :REL2ABS "%SITESPEC%\..\.."
set "SITEBASE=%RETVAL%"
echo SITEBASE=%SITEBASE%

rem use call so that control will return to the calling batch file.
call "%SITEBASE%\github\tpsup\bat\tpsup.cmd"

rem the following will be used by tpsup/bat/p3env.exe
set "TP_P3_PATH=C:\Program Files\Python312;C:\Program Files\Python312\Scripts;C:\Users\%USERNAME%\AppData\Roaming\Python\Python312\Scripts"
echo TP_P3_PATH=%TP_P3_PATH%

set "SITEVENV=%SITEBASE%\python3\venv\Windows\win10-python3.12"
echo SITEVENV=%SITEVENV%

rem set ANDROID_HOME
set "ANDROID_HOME=C:\Users\%USERNAME%\AppData\Local\Android\Sdk"
echo ANDROID_HOME=%ANDROID_HOME%

:: ========== FUNCTIONS ==========
EXIT /B

:: https://stackoverflow.com/questions/1645843/resolve-absolute-path-from-relative-path-and-or-file-name
:REL2ABS
  SET RETVAL=%~f1
  EXIT /B
