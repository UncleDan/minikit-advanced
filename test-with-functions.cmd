@echo off
setlocal enabledelayedexpansion

:::::::::::::::::::::::::::::::::::::::::::::::::: Variabili globali - INIZIO
:: Mini-Kit Advanced by Daniele Lolli (UncleDan)
set "SCRIPT_NAME=Mini-Kit Advanced"
set "SCRIPT_AUTHOR=Daniele Lolli (UncleDan)"
set "SCRIPT_VERSION=25.12.18"
set "SCRIPT_FULLNAME=%~nx0"
set "SCRIPT_NAME_NOEXT=%~n0"
set "SCRIPT_PATH=%~dp0"
set "Supremo_URL=https://www.nanosystems.it/public/download/Supremo.exe"
set "FREEFILESYNC_URL=https://freefilesync.org/download/FreeFileSync_14.6_Windows_Setup.exe"
:::::::::::::::::::::::::::::::::::::::::::::::::: Variabili globali - FINE

:::::::::::::::::::::::::::::::::::::::::::::::::: Programma principale - INIZIO

if "%~1"=="" call :SHOW_HELP & goto :EOF

for %%a in (%*) do (

    if /i "%%~a"=="-h" call :SHOW_HELP & goto :EOF
    if /i "%%~a"=="--help" call :SHOW_HELP & goto :EOF

    if /i "%%~a"=="-7" call :INSTALL_SOFTWARE "7-Zip" "7zip.7zip" "winget"
    if /i "%%~a"=="--7zip" call :INSTALL_SOFTWARE "7-Zip" "7zip.7zip" "winget"
    
)

echo  Vediamo altro...
goto EOF
:::::::::::::::::::::::::::::::::::::::::::::::::: Programma principale - FINE

:::::::::::::::::::::::::::::::::::::::::::::::::: Visualizzazione aiuto - INIZIO
:SHOW_HELP
setlocal
echo.
echo USO:
echo   %SCRIPT_FULLNAME% [OPZIONI]
echo.
echo OPZIONI:
echo   -7, --7zip         Installa 7-Zip
echo   -a, --adobe        Installa Adobe Reader
echo   -c, --chrome       Installa Google Chrome
echo   -s, --speccy       Installa Speccy
echo   -l, --libreoffice  Installa LibreOffice 
echo   -d, --supremo      Scarica Supremo Remote Desktop
echo.
echo   -k, --kit          Installa kit base + aggiornamento pacchetti
echo.
echo   -p, --powershell   Installa PowerShell
echo   -b, --backup       Installa Veeam Agent
echo   -f, --firefox      Installa Mozilla Firefox (italiano)
echo   -r, --thunderbird  Installa Mozilla Thunderbird (italiano)
echo   -n, --notepad      Installa Notepad++
echo   -e, --freefilesync Installa FreeFileSync
echo   -t, --teamviewer   Installa TeamViewer
echo   -v, --vscode       Installa Visual Studio Code
echo   -w, --winutil      Esegue Chris Titus Tech WinUtil
echo   -u, --update       Aggiorna pacchetti 
echo.
endlocal & exit /b 1
:::::::::::::::::::::::::::::::::::::::::::::::::: Visualizzazione aiuto - FINE

:::::::::::::::::::::::::::::::::::::::::::::::::: Definizione della funzione di installazione software - INIZIO
:INSTALL_SOFTWARE
setlocal
set "software_name=%~1"
set "id_file=%~2"
set "method=%~3"
set "extra_params=%~4"

:: CONTROLLO 1: Verifica parametri obbligatori
if "%~3"=="" (
    :: [ERRORE] Parametri insufficienti!
    :: Utilizzo: call :INSTALL_SOFTWARE "NomeSoftware" "ID/File" "Metodo" ["ParametriExtra"]
    ::
    :: Metodi validi: "winget" o "direct"
    :: ParametriExtra: opzionali, parametri aggiuntivi per l'installatore
    ::
    :: Esempi:
    ::   call :INSTALL_SOFTWARE "7zip" "7zip.7zip" "winget"
    ::   call :INSTALL_SOFTWARE "Firefox" "install" "direct" "/S"
    ::   call :INSTALL_SOFTWARE "App" "uninstall" "winget" "--force"
    goto :ERROR_EXIT
)

:: CONTROLLO 2: Verifica terzo parametro valido
if /i not "%method%"=="winget" (
    if /i not "%method%"=="direct" (
        :: [ERRORE] Metodo di installazione non valido: "%method%"
        :: Metodi accettati: "winget" o "direct"
        goto :ERROR_EXIT
    )
)

echo [%time%] Installazione "%software_name%" con metodo "%method%"... >> "%logfile%"
echo Installazione "%software_name%" con metodo "%method%"...

:: SCELTA DEL METODO DI INSTALLAZIONE
if /i "%method%"=="winget" (
    winget install -h --id "%id_file%" --accept-package-agreements --accept-source-agreements
) else if /i "%method%"=="direct" (
    echo :INSTALL_DIRECT "%software_name%" "%id_file%" "%extra_params%"
)

:: Verifica risultato
if errorlevel 0 (
    echo [SUCCESSO] Operazione completata con successo!
    endlocal & exit /b 0
) else (
    goto :ERROR_EXIT
)

:ERROR_EXIT
echo [FALLITO] Operazione non riuscita. Codice errore: %errorlevel%
endlocal & exit /b 1
:::::::::::::::::::::::::::::::::::::::::::::::::: Definizione della funzione di installazione software - FINE

:EOF
