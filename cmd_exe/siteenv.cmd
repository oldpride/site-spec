@echo off

rem For convenience, add a a wrapper script at cmd.exe's home dir, so that user can run it once cmd.exe launched.
rem the wrapper script can be named the same for consistency,  %HOMEDRIVE%%HOMEPATH%\siteenv.cmd which has
rem just one line
rem    call "C:\users\%username%\sitebase\github\site-spec\cmd_exe\siteenv.cmd"
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
call "%SITEBASE%\github\tpsup\cmd_exe\tpsup.cmd"

rem the following will be used by tpsup/cmd_exe/p3env.exe
set "TP_P3_PATH=C:\Program Files\Python3.10;C:\Program Files\Python3.10\Scripts;C:\Users\%USERNAME%\AppData\Roaming\Python\Python310\Scripts"
rem set "TP_P3_PYTHONPATH=%SITEBASE%\Windows\Win10-Python3.7\lib\site-packages" 
rem call p3env

set "SITEVENV=%SITEBASE%\python3\venv\Windows\win10-python3.10"

:: ========== FUNCTIONS ==========
EXIT /B

:: https://stackoverflow.com/questions/1645843/resolve-absolute-path-from-relative-path-and-or-file-name
:REL2ABS
  SET RETVAL=%~f1
  EXIT /B
