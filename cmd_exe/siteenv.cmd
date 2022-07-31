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
set "SITEBASE=C:\users\%username%\sitebase"
set "SITESPEC=C:\users\%username%\sitebase\github\site-spec"

# use call so that control will return to the calling batch file.
call "%SITEBASE%\github\tpsup\cmd_exe\tpsup"

rem the following will be used by tpsup/cmd_exe/p3env.exe
set "TP_P3_PATH=C:\Program Files\Python3.10;C:\Program Files\Python3.10\Scripts"
set "TP_P3_PATHPATH=%SITEBASE%\Windows\Win10-Python3.7\lib\site-packages"
rem call p3env

addpath PATH "%SITESPEC%\cmd_exe"
