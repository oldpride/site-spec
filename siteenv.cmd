@echo off

rem copy or link this file to %USERPROFILE%/siteenv.cmd.
rem %USERPROFILE% sometimes is C:\Users\%USERNAME%, sometimes not, for example, it could be H:\

rem 1. copy is a better way as then you can modify it

rem 2. in case you set up a link under user home dir. this requires admin access
rem    run cmd.exe as administrator
rem    cd C:\Users\william
rem    C:\Users\william>mklink siteenv.cmd sitebase\github\site-spec\siteenv.cmd
rem    symbolic link created for siteenv.cmd <<===>> sitebase\github\tpsup\env\siteenv.cmd

rem don't use setx. setx will permanently change the setting
set "SITEBASE=C:\users\%username%\sitebase"

# use call so that control will return to the calling batch file.
call "%SITEBASE%\github\tpsup\cmd_exe\tpsup"

set "TP_P3_PATH=C:\Program Files\Python3.10;C:\Program Files\Python3.10\Scripts"
set "TP_P3_PATHPATH=%SITEBASE%\Windows\Win10-Python3.7\lib\site-packages"

rem p3env


