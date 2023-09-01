set LIB=%SCRIPTPATH%lib\launcher.fnl
set FENNEL=%SCRIPTPATH%fennel
set GLOBALS=*file*,*project*,pattern-quote,unpack

fennel -e "(require :luv)" >NUL 2>NUL

if %ERRORLEVEL% NEQ 0 goto :lua

fennel --globals %GLOBALS% %LIB% %ACTION% %*
exit %ERRORLEVEL%

:lua
lua -e "require'luv'" >NUL 2>NUL

if %ERRORLEVEL% NEQ 0 goto :luajit

lua %FENNEL% --globals %GLOBALS% %LIB% %ACTION% %*
exit %ERRORLEVEL%

:luajit
luajit -e "require'luv'" >NUL 2>NUL

if %ERRORLEVEL% NEQ 0 goto :nvim

luajit %FENNEL% --globals %GLOBALS% %LIB% %ACTION% %*
exit %ERRORLEVEL%

:nvim
where nvim >NUL 2>NUL

if %ERRORLEVEL% NEQ 0 goto :notfound

nvim -u NONE --headless -l %FENNEL% --globals %GLOBALS% %LIB% %ACTION% %*
exit %ERRORLEVEL%

:notfound
echo Cannot find a valid lua version with luv support >&2
exit 1
