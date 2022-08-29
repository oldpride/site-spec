@echo off

set "prog=%~n0"
set "SITEBASE=%~dp0"

:: use call so that the ending of the command will not end this whole script
call "%SITEBASE%github\site-spec\cmd_exe\siteenv.cmd"

set "PATH=%SITEBASE%github\dice\scripts;%PATH%"
cd "%SITEBASE%/github/dice/scripts"
call p3env
call svenv

