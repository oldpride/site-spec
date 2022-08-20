@echo off

set "prog=%~n0"
set "SITEBASE=%~dp0"

call "%SITEBASE%github\site-spec\cmd_exe\siteenv.cmd"
call p3env
call svenv

call pyslnm_test_input auto s=henry

call venv
