:: This script starts the Jupyter Notebook server and copies the link to the 
:: clipboard. The user is required to press any key, as time needed to start
:: the server may vary. 
:: This script is handy for opening Notebook in a non-default browser, e.g.
:: in the private/incognito/porn mode.
::
:: Assumptions are made regarding paths and system configuration.
:: 22:12 16/08/2019 Andrey V. Melnik


:: activate a conda environment
call conda.bat activate

:: Run jupyter notebook as a separate process 
start jupyter-notebook --no-browser

:: We'll need to define some variables, so to avoid any potential conflict:
@ECHO OFF
SETLOCAL
@ECHO Press any key (after conda loads Jupyter Notebook Server) ...
@PAUSE >NUL

:: parse the jupyter\runtime directory for the latest modified *.json file
:: --> Modify below if your jupyter runtime folder is different
PUSHD %APPDATA%\jupyter\runtime
for /f "tokens=*" %%a in ('dir *.json /b /od') do set newest=%%a

:: parse the 8th line of the file to get the token
FOR /F "eol=; skip=8 tokens=2 delims=, " %%i in (%newest%) do (SET str=%%~i && GOTO :lbl1)
:lbl1

:: parse the 9th line of the file to get the address:port
FOR /F "eol=; skip=9 tokens=2 delims=, " %%i in (%newest%) do (SET addr=%%~i && GOTO :lbl2)
:lbl2
:: remove spaces (%str% has a trailing space, which we don't need in the link)
SET addr=%addr: =%

:: copy the link to the clipboard
@ECHO %addr%?token=%str% | CLIP

POPD
ENDLOCAL
ECHO on
EXIT