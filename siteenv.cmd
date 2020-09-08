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
call %SITEBASE%\github\tpsup\cmd_exe\tpsup

call addpath PYTHONPATH "%SITEBASE%\Windows\Win10-Python3.7\lib\site-packages"


