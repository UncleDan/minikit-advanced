@echo off
setlocal enabledelayedexpansion

REM Mini-Kit Advanced by Daniele Lolli (UncleDan)
set "SCRIPT_NAME=Mini-Kit Advanced"
set "SCRIPT_AUTHOR=Daniele Lolli (UncleDan)"
set "SCRIPT_VERSION=25.12"
set "SCRIPT_FULLNAME=%~nx0"
set "SCRIPT_NAME_NOEXT=%~n0"
set "SCRIPT_PATH=%~dp0"
set "SUPREMO_URL=https://www.nanosystems.it/public/download/Supremo.exe"
set "FREEFILESYNC_URL=https://freefilesync.org/download/FreeFileSync_14.6_Windows_Setup.exe"

REM Configura data per log
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set "datetime=%%I"
set "year=!datetime:~0,4!"
set "month=!datetime:~4,2!"
set "day=!datetime:~6,2!"
set "hour=!datetime:~8,2!"
set "minute=!datetime:~10,2!"
set "logfile=%SCRIPT_PATH%%SCRIPT_NAME_NOEXT%_!year!-!month!-!day!_!hour!-!minute!.log"

cls
echo ======================================================================
echo %SCRIPT_NAME% v%SCRIPT_VERSION% - %SCRIPT_AUTHOR%
echo ======================================================================
echo INSTALLAZIONE AUTOMATICA SOFTWARE WINDOWS
echo ======================================================================

REM Se nessun parametro, mostra help
if "%~1"=="" goto SHOW_HELP

REM Inizializza variabili per le opzioni
set "INSTALL_7ZIP=0"
set "INSTALL_ADOBE=0"
set "INSTALL_CHROME=0"
set "INSTALL_SPECCY=0"
set "INSTALL_LIBREOFFICE=0"
set "DOWNLOAD_SUPREMO=0"
set "INSTALL_POWERSHELL=0"
set "INSTALL_VEEAM=0"
set "INSTALL_FIREFOX=0"
set "INSTALL_THUNDERBIRD=0"
set "INSTALL_NOTEPAD=0"
set "INSTALL_FREEFILESYNC=0"
set "INSTALL_TEAMVIEWER=0"
set "INSTALL_VSCODE=0"
set "RUN_WINUTIL=0"
set "INSTALL_KIT=0"
set "UPDATE_PKGS=0"

REM Parsa tutti i parametri
:PARSE_LOOP

REM Inizializza il file log
echo Log: %logfile%
echo.
(
echo ======================================================================
echo %SCRIPT_NAME% v%SCRIPT_VERSION% - %SCRIPT_AUTHOR%
echo ======================================================================
echo INSTALLAZIONE AUTOMATICA SOFTWARE WINDOWS
echo ======================================================================
echo Data esecuzione: !year!-!month!-!day! !hour!:!minute!
echo. 
) > "%logfile%"

if "%~1"=="" goto PARSE_DONE

echo [%time%] Analisi parametro: %~1 >> "%logfile%"

if /i "%~1"=="-7" set "INSTALL_7ZIP=1"
if /i "%~1"=="--7zip" set "INSTALL_7ZIP=1"

if /i "%~1"=="-a" set "INSTALL_ADOBE=1"
if /i "%~1"=="--adobe" set "INSTALL_ADOBE=1"

if /i "%~1"=="-c" set "INSTALL_CHROME=1"
if /i "%~1"=="--chrome" set "INSTALL_CHROME=1"

if /i "%~1"=="-s" set "INSTALL_SPECCY=1"
if /i "%~1"=="--speccy" set "INSTALL_SPECCY=1"

if /i "%~1"=="-l" set "INSTALL_LIBREOFFICE=1"
if /i "%~1"=="--libreoffice" set "INSTALL_LIBREOFFICE=1"

if /i "%~1"=="-d" set "DOWNLOAD_SUPREMO=1"
if /i "%~1"=="--supremo" set "DOWNLOAD_SUPREMO=1"

if /i "%~1"=="-k" set "INSTALL_KIT=1"
if /i "%~1"=="--kit" set "INSTALL_KIT=1"

if /i "%~1"=="-p" set "INSTALL_POWERSHELL=1"
if /i "%~1"=="--powershell" set "INSTALL_POWERSHELL=1"

if /i "%~1"=="-b" set "INSTALL_VEEAM=1"
if /i "%~1"=="--backup" set "INSTALL_VEEAM=1"

if /i "%~1"=="-f" set "INSTALL_FIREFOX=1"
if /i "%~1"=="--firefox" set "INSTALL_FIREFOX=1"

if /i "%~1"=="-r" set "INSTALL_THUNDERBIRD=1"
if /i "%~1"=="--thunderbird" set "INSTALL_THUNDERBIRD=1"

if /i "%~1"=="-n" set "INSTALL_NOTEPAD=1"
if /i "%~1"=="--notepad" set "INSTALL_NOTEPAD=1"

if /i "%~1"=="-e" set "INSTALL_FREEFILESYNC=1"
if /i "%~1"=="--freefilesync" set "INSTALL_FREEFILESYNC=1"

if /i "%~1"=="-t" set "INSTALL_TEAMVIEWER=1"
if /i "%~1"=="--teamviewer" set "INSTALL_TEAMVIEWER=1"

if /i "%~1"=="-v" set "INSTALL_VSCODE=1"
if /i "%~1"=="--vscode" set "INSTALL_VSCODE=1"

if /i "%~1"=="-w" set "RUN_WINUTIL=1"
if /i "%~1"=="--winutil" set "RUN_WINUTIL=1"

if /i "%~1"=="-u" set "UPDATE_PKGS=1"
if /i "%~1"=="--update" set "UPDATE_PKGS=1"

shift
goto PARSE_LOOP

:PARSE_DONE

REM Verifica Winget prima di procedere
echo Verifica Winget...
winget --version >nul 2>&1
if errorlevel 1 (
    echo ERRORE: Winget non trovato!
    echo [%time%] ✗ ERRORE: Winget non trovato >> "%logfile%"
    echo Installare Windows Package Manager per continuare.
    pause
    goto EOF
)

echo ✓ Winget trovato. Inizio installazioni...
echo [%time%] ✓ Winget trovato >> "%logfile%"
echo.

REM Se richiesto kit completo
if "!INSTALL_KIT!"=="1" (
    echo [Kit] Installazione pacchetto completo...
    echo [%time%] [Kit] Installazione pacchetto completo >> "%logfile%"
    set "INSTALL_7ZIP=1"
    set "INSTALL_ADOBE=1"
    set "INSTALL_CHROME=1"
    set "INSTALL_SPECCY=1"
    set "INSTALL_LIBREOFFICE=1"
    set "DOWNLOAD_SUPREMO=1"
    set "UPDATE_PKGS=1"
)

REM Aggiornamento pacchetti se richiesto
if "!UPDATE_PKGS!"=="1" (
    echo Aggiornamento pacchetti in corso...
    echo [%time%] Aggiornamento pacchetti winget >> "%logfile%"
    call :UPDATE_PACKAGES
)

REM Aggiornamento automatico se incluso nel kit
if "!UPDATE_PKGS!"=="1" (
    if not defined KIT_UPDATED (
        echo Aggiornamento pacchetti (incluso nel kit)...
        echo [%time%] Aggiornamento pacchetti (kit) >> "%logfile%"
        call :UPDATE_PACKAGES
        set "KIT_UPDATED=1"
    )
)

REM Esegue le installazioni in base ai flag
if "!INSTALL_7ZIP!"=="1" call :INSTALL_7ZIP
if "!INSTALL_ADOBE!"=="1" call :INSTALL_ADOBE_READER
if "!INSTALL_CHROME!"=="1" call :INSTALL_GOOGLE_CHROME
if "!INSTALL_SPECCY!"=="1" call :INSTALL_SPECCY
if "!INSTALL_LIBREOFFICE!"=="1" call :INSTALL_LIBREOFFICE
if "!DOWNLOAD_SUPREMO!"=="1" call :DOWNLOAD_SUPREMO
if "!INSTALL_POWERSHELL!"=="1" call :INSTALL_POWERSHELL
if "!INSTALL_VEEAM!"=="1" call :INSTALL_VEEAM
if "!INSTALL_FIREFOX!"=="1" call :INSTALL_FIREFOX
if "!INSTALL_THUNDERBIRD!"=="1" call :INSTALL_THUNDERBIRD
if "!INSTALL_NOTEPAD!"=="1" call :INSTALL_NOTEPAD
if "!INSTALL_FREEFILESYNC!"=="1" call :INSTALL_FREEFILESYNC
if "!INSTALL_TEAMVIEWER!"=="1" call :INSTALL_TEAMVIEWER
if "!INSTALL_VSCODE!"=="1" call :INSTALL_VSCODE
if "!RUN_WINUTIL!"=="1" call :RUN_WINUTIL

goto COMPLETED

:SHOW_HELP
echo.
echo USO:
echo   %SCRIPT_FULLNAME% [OPZIONI]
echo.
echo OPZIONI:
echo   -7, --7zip         Installa 7-Zip
echo   -a, --adobe        Installa Adobe Reader (italiano)
echo   -c, --chrome       Installa Google Chrome (italiano)
echo   -s, --speccy       Installa Speccy
echo   -l, --libreoffice  Installa LibreOffice (italiano)
echo   -d, --supremo      Scarica Supremo Remote Desktop
echo.
echo   -k, --kit          Installa kit base + aggiornamento
echo.
echo   -p, --powershell   Installa PowerShell
echo   -b, --backup       Installa Veeam Agent
echo   -f, --firefox      Installa Mozilla Firefox (italiano)
echo   -r, --thunderbird  Installa Mozilla Thunderbird (italiano)
echo   -n, --notepad      Installa Notepad++ (italiano)
echo   -e, --freefilesync Installa FreeFileSync
echo   -t, --teamviewer   Installa TeamViewer (italiano)
echo   -v, --vscode       Installa Visual Studio Code
echo   -w, --winutil      Esegue Chris Titus Tech WinUtil
echo   -u, --update       Aggiorna pacchetti prima di installare
echo.
echo NOTA: Il kit base (-k) include automaticamente l'aggiornamento (-u)
echo.
goto EOF

REM --- FUNZIONE AGGIORNAMENTO PACCHETTI ---
:UPDATE_PACKAGES
echo [%time%] Aggiornamento pacchetti... >> "%logfile%"
echo Aggiornamento pacchetti winget in corso...
winget update --all --include-unknown --accept-package-agreements --accept-source-agreements
if !errorlevel! equ 0 (
    echo [%time%] ✓ Aggiornamento completato >> "%logfile%"
    echo ✓ Aggiornamento completato
) else (
    echo [%time%] ✗ Errore aggiornamento >> "%logfile%"
    echo ✗ Errore aggiornamento
)
exit /b

REM --- FUNZIONI DI INSTALLAZIONE CON LOG ERRORI ---
:INSTALL_7ZIP
echo [%time%] Installazione 7-Zip... >> "%logfile%"
echo Installazione 7-Zip...
winget install -h --id 7zip.7zip --accept-package-agreements --accept-source-agreements
if !errorlevel! equ 0 (
    echo [%time%] ✓ 7-Zip installato >> "%logfile%"
    echo ✓ 7-Zip installato
) else (
    echo [%time%] ✗ Errore installazione 7-Zip >> "%logfile%"
    echo ✗ Errore installazione 7-Zip
)
exit /b

:INSTALL_ADOBE_READER
echo [%time%] Installazione Adobe Reader IT... >> "%logfile%"
echo Installazione Adobe Reader IT...
winget install -h --id Adobe.Acrobat.Reader.64-bit --accept-package-agreements --accept-source-agreements
if !errorlevel! equ 0 (
    echo [%time%] ✓ Adobe Reader installato >> "%logfile%"
    echo ✓ Adobe Reader installato
) else (
    echo [%time%] ✗ Errore installazione Adobe Reader >> "%logfile%"
    echo ✗ Errore installazione Adobe Reader
)
exit /b

:INSTALL_GOOGLE_CHROME
echo [%time%] Installazione Google Chrome IT... >> "%logfile%"
echo Installazione Google Chrome IT...
winget install -h --id Google.Chrome --accept-package-agreements --accept-source-agreements
if !errorlevel! equ 0 (
    echo [%time%] ✓ Google Chrome installato >> "%logfile%"
    echo ✓ Google Chrome installato
) else (
    echo [%time%] ✗ Errore installazione Google Chrome >> "%logfile%"
    echo ✗ Errore installazione Google Chrome
)
exit /b

:INSTALL_SPECCY
echo [%time%] Installazione Speccy... >> "%logfile%"
echo Installazione Speccy...
winget install -h --id Piriform.Speccy --accept-package-agreements --accept-source-agreements
if !errorlevel! equ 0 (
    echo [%time%] ✓ Speccy installato >> "%logfile%"
    echo ✓ Speccy installato
) else (
    echo [%time%] ✗ Errore installazione Speccy >> "%logfile%"
    echo ✗ Errore installazione Speccy
)
exit /b

:INSTALL_LIBREOFFICE
echo [%time%] Installazione LibreOffice IT... >> "%logfile%"
echo Installazione LibreOffice IT...
winget install -h --id TheDocumentFoundation.LibreOffice --accept-package-agreements --accept-source-agreements
if !errorlevel! equ 0 (
    echo [%time%] ✓ LibreOffice installato >> "%logfile%"
    echo ✓ LibreOffice installato
) else (
    echo [%time%] ✗ Errore installazione LibreOffice >> "%logfile%"
    echo ✗ Errore installazione LibreOffice
)
exit /b

:DOWNLOAD_SUPREMO
echo [%time%] Download Supremo... >> "%logfile%"
echo Download Supremo...
powershell -Command "Invoke-WebRequest -Uri '%SUPREMO_URL%' -OutFile 'C:\Users\Public\Desktop\Supremo.exe'"
if exist "C:\Users\Public\Desktop\Supremo.exe" (
    echo [%time%] ✓ Supremo scaricato >> "%logfile%"
    echo ✓ Supremo scaricato sul desktop pubblico
) else (  
    echo [%time%] ✗ Download Supremo fallito >> "%logfile%"
    echo ✗ Download Supremo fallito
)
exit /b

:INSTALL_POWERSHELL
echo [%time%] Installazione PowerShell... >> "%logfile%"
echo Installazione PowerShell...
winget install -h --id Microsoft.PowerShell -e --accept-package-agreements --accept-source-agreements
if !errorlevel! equ 0 (
    echo [%time%] ✓ PowerShell installato >> "%logfile%"
    echo ✓ PowerShell installato
) else (
    echo [%time%] ✗ Errore installazione PowerShell >> "%logfile%"
    echo ✗ Errore installazione PowerShell
)
exit /b

:INSTALL_VEEAM
echo [%time%] Installazione Veeam Agent... >> "%logfile%"
echo Installazione Veeam Agent...
winget install -h --id Veeam.VeeamAgent -e --accept-package-agreements --accept-source-agreements
if !errorlevel! equ 0 (
    echo [%time%] ✓ Veeam Agent installato >> "%logfile%"
    echo ✓ Veeam Agent installato
) else (
    echo [%time%] ✗ Errore installazione Veeam Agent >> "%logfile%"
    echo ✗ Errore installazione Veeam Agent
)
exit /b

:INSTALL_FIREFOX
echo [%time%] Installazione Firefox IT... >> "%logfile%"
echo Installazione Firefox IT...
winget install -h --id Mozilla.Firefox.it -e --accept-package-agreements --accept-source-agreements
if !errorlevel! equ 0 (
    echo [%time%] ✓ Firefox installato >> "%logfile%"
    echo ✓ Firefox installato
) else (
    echo [%time%] ✗ Errore installazione Firefox >> "%logfile%"
    echo ✗ Errore installazione Firefox
)
exit /b

:INSTALL_THUNDERBIRD
echo [%time%] Installazione Thunderbird IT... >> "%logfile%"
echo Installazione Thunderbird IT...
winget install -h --id Mozilla.Thunderbird.it -e --accept-package-agreements --accept-source-agreements
if !errorlevel! equ 0 (
    echo [%time%] ✓ Thunderbird installato >> "%logfile%"
    echo ✓ Thunderbird installato
) else (
    echo [%time%] ✗ Errore installazione Thunderbird >> "%logfile%"
    echo ✗ Errore installazione Thunderbird
)
exit /b

:INSTALL_NOTEPAD
echo [%time%] Installazione Notepad++ IT... >> "%logfile%"
echo Installazione Notepad++ IT...
winget install -h --id Notepad++.Notepad++ -e --accept-package-agreements --accept-source-agreements
if !errorlevel! equ 0 (
    echo [%time%] ✓ Notepad++ installato >> "%logfile%"
    echo ✓ Notepad++ installato
) else (
    echo [%time%] ✗ Errore installazione Notepad++ >> "%logfile%"
    echo ✗ Errore installazione Notepad++
)
exit /b

:INSTALL_FREEFILESYNC
echo [%time%] Download e Installazione FreeFileSync... >> "%logfile%"
echo Download e Installazione FreeFileSync...
powershell -Command "Invoke-WebRequest -Uri '%FREEFILESYNC_URL%' -OutFile '%TEMP%\FreeFileSync_Windows_Setup.exe'"
if exist "%TEMP%\FreeFileSync_Windows_Setup.exe" (
    echo [%time%] ✓ FreeFileSync scaricato >> "%logfile%"
    echo ✓ FreeFileSync scaricato
    start /wait "" "%TEMP%\FreeFileSync_Windows_Setup.exe" 
    if !errorlevel! equ 0 (
        echo [%time%] ✓ FreeFileSync installato >> "%logfile%"
        echo ✓ FreeFileSync installato
    ) else (
        echo [%time%] ✗ Errore installazione FreeFileSync >> "%logfile%"
        echo ✗ Errore installazione FreeFileSync
    )
) else (  
    echo [%time%] ✗ Download FreeFileSync fallito >> "%logfile%"
    echo ✗ Download FreeFileSync fallito
)
exit /b

:INSTALL_TEAMVIEWER
echo [%time%] Installazione TeamViewer IT... >> "%logfile%"
echo Installazione TeamViewer IT...
winget install -h --id TeamViewer.TeamViewer -e --accept-package-agreements --accept-source-agreements
if !errorlevel! equ 0 (
    echo [%time%] ✓ TeamViewer installato >> "%logfile%"
    echo ✓ TeamViewer installato
) else (
    echo [%time%] ✗ Errore installazione TeamViewer >> "%logfile%"
    echo ✗ Errore installazione TeamViewer
)
exit /b

:INSTALL_VSCODE
echo [%time%] Installazione Visual Studio Code... >> "%logfile%"
echo Installazione Visual Studio Code...
winget install -h --id Microsoft.VisualStudioCode -e --accept-package-agreements --accept-source-agreements
if !errorlevel! equ 0 (
    echo [%time%] ✓ VS Code installato >> "%logfile%"
    echo ✓ VS Code installato
) else (
    echo [%time%] ✗ Errore installazione VS Code >> "%logfile%"
    echo ✗ Errore installazione VS Code
)
exit /b

:RUN_WINUTIL
echo [%time%] Esecuzione WinUtil... >> "%logfile%"
echo Avvio WinUtil...
powershell -Command "irm https://christitus.com/win | iex"
if !errorlevel! equ 0 (
    echo [%time%] ✓ WinUtil eseguito >> "%logfile%"
    echo ✓ WinUtil eseguito
) else (
    echo [%time%] ✗ Errore esecuzione WinUtil >> "%logfile%"
    echo ✗ Errore esecuzione WinUtil
)
exit /b

:COMPLETED
echo. >> "%logfile%"
echo ====================================================================== >> "%logfile%"
echo [%time%] ✓ INSTALLAZIONE COMPLETATA >> "%logfile%"
echo ====================================================================== >> "%logfile%"

echo.
echo ======================================================================
echo %SCRIPT_NAME% v%SCRIPT_VERSION% - INSTALLAZIONE COMPLETATA
echo ======================================================================
echo.
echo 📄 Log completo: %logfile%
echo.

:EOF
endlocal