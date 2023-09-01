@echo off

set SCRIPTPATH=%~dp0
set ACTION=install

call %SCRIPTPATH%\lib\launcher.bat %*
