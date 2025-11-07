@echo off
setlocal enabledelayedexpansion

REM Mini-Kit Advanced v25.11 by Daniele Lolli (UncleDan)
REM Script di installazione software per Windows - Modalità Batch

set "SCRIPT_NAME=Mini-Kit Advanced"
set "SCRIPT_AUTHOR=Daniele Lolli (UncleDan)"
set "SCRIPT_VERSION=25.11"

REM Ottiene il nome completo del file in esecuzione e il percorso
set "SCRIPT_FULLNAME=%~nx0"
set "SCRIPT_NAME_NOEXT=%~n0"
set "SCRIPT_PATH=%~dp0"

REM Controlla se *NON* ci sono parametri
if "%~1"=="" goto NO_PARAMS

REM Se ci sono, analizza i parametri
set "INSTALL_ONLY_BASE=0"
set "INSTALL_POWERSHELL=0"
set "INSTALL_VEEAM=0"
set "INSTALL_FIREFOX=0"
set "INSTALL_THUNDERBIRD=0"
set "INSTALL_NOTEPAD=0"
set "INSTALL_TEAMVIEWER=0"
set "INSTALL_VSCODE=0"

:PARSE_LOOP
if "%~1"=="" goto MAIN
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
if /i "%~1"=="-t" set "INSTALL_TEAMVIEWER=1"
if /i "%~1"=="--teamviewer" set "INSTALL_TEAMVIEWER=1"
if /i "%~1"=="-v" set "INSTALL_VSCODE=1"
if /i "%~1"=="--vscode" set "INSTALL_VSCODE=1"
if /i "%~1"=="-w" goto RUN_WINUTIL
if /i "%~1"=="--winutil" goto RUN_WINUTIL
if /i "%~1"=="-h" goto SHOW_HELP
if /i "%~1"=="--help" goto SHOW_HELP
if /i "%~1"=="/?" goto SHOW_HELP

shift
goto PARSE_LOOP

:NO_PARAMS
set "INSTALL_ONLY_BASE=1"

:MAIN
REM Configurazione percorso e nome file log con formato migliorato
for /f "tokens=1-3 delims=/" %%a in ('date /t') do (
    set "year=%%c"
    set "month=%%a"
    set "day=%%b"
)
for /f "tokens=1-2 delims=:" %%a in ('time /t') do (
    set "hour=%%a"
    set "minute=%%b"
)

REM Rimuove tutti gli spazi
set "year=!year: =!"
set "month=!month: =!"
set "day=!day: =!"
set "hour=!hour: =!"
set "minute=!minute: =!"

REM Aggiunge zero davanti ai numeri singoli (dopo aver rimosso gli spazi)
if "!month!" lss "10" set "month=0!month!"
if "!day!" lss "10" set "day=0!day!"
if "!hour!" lss "10" set "hour=0!hour!"
if "!minute!" lss "10" set "minute=0!minute!"

set "logfile=%SCRIPT_PATH%%SCRIPT_NAME_NOEXT%_!year!-!month!-!day!_!hour!-!minute!.log"

cls
echo ======================================================================
echo %SCRIPT_NAME% v%SCRIPT_VERSION% - %SCRIPT_AUTHOR%
echo ======================================================================
echo INSTALLAZIONE AUTOMATICA SOFTWARE WINDOWS
echo ======================================================================
echo Log: %logfile%
echo.

echo ====================================================================== >> "%logfile%"
echo %SCRIPT_NAME% v%SCRIPT_VERSION% - %SCRIPT_AUTHOR% >> "%logfile%"
echo ====================================================================== >> "%logfile%"
echo INSTALLAZIONE AUTOMATICA SOFTWARE WINDOWS >> "%logfile%"
echo ====================================================================== >> "%logfile%"
echo Log: %logfile% >> "%logfile%"
echo. >> "%logfile%"

if !INSTALL_ONLY_BASE!==1 (
    echo NESSUN PARAMETRO: Installazione SOLO software base
    echo ----------------------------------------------------------------------
    echo.

    echo [%time%] NESSUN PARAMETRO: Installazione SOLO software base >> "%logfile%"
    echo [%time%] ---------------------------------------------------------------------- >> "%logfile%"

) else (
    echo PARAMETRI RILEVATI: Installazione SOLO software opzionali specificati
    echo CONFIGURAZIONE INSTALLAZIONE:
    echo    Software base: NO
    echo    Software opzionali: SI
    echo ----------------------------------------------------------------------
    echo.

    echo [%time%] PARAMETRI RILEVATI: Installazione SOLO software opzionali specificati >> "%logfile%"
    echo [%time%] CONFIGURAZIONE INSTALLAZIONE: >> "%logfile%"
    echo [%time%]   Software base: NO >> "%logfile%"

    set "OPTIONAL_COUNT=0"
    if !INSTALL_POWERSHELL!==1 set /a "OPTIONAL_COUNT+=1" && echo [%time%]   PowerShell: SI >> "%logfile%"
    if !INSTALL_VEEAM!==1 set /a "OPTIONAL_COUNT+=1" && echo [%time%]   Veeam Agent: SI >> "%logfile%"
    if !INSTALL_FIREFOX!==1 set /a "OPTIONAL_COUNT+=1" && echo [%time%]   Firefox: SI >> "%logfile%"
    if !INSTALL_THUNDERBIRD!==1 set /a "OPTIONAL_COUNT+=1" && echo [%time%]   Thunderbird: SI >> "%logfile%"
    if !INSTALL_NOTEPAD!==1 set /a "OPTIONAL_COUNT+=1" && echo [%time%]   Notepad++: SI >> "%logfile%"
    if !INSTALL_TEAMVIEWER!==1 set /a "OPTIONAL_COUNT+=1" && echo [%time%]   TeamViewer: SI >> "%logfile%"
    if !INSTALL_VSCODE!==1 set /a "OPTIONAL_COUNT+=1" && echo [%time%]   VS Code: SI >> "%logfile%"

    echo [%time%]   Software opzionali selezionati: !OPTIONAL_COUNT! >> "%logfile%"
    echo [%time%] ---------------------------------------------------------------------- >> "%logfile%"

)

goto CHECK_WINGET

:SHOW_HELP
echo.
echo %SCRIPT_NAME% v%SCRIPT_VERSION% - %SCRIPT_AUTHOR%
echo.
echo USO:
echo   %SCRIPT_FULLNAME% [OPZIONI]
echo.
echo OPZIONI:
echo   -p, --powershell    Installa PowerShell
echo   -b, --backup        Installa Veeam Agent per backup
echo   -f, --firefox       Installa Mozilla Firefox ^(italiano^)
echo   -r, --thunderbird   Installa Mozilla Thunderbird ^(italiano^)
echo   -n, --notepad       Installa Notepad++ ^(italiano^)
echo   -t, --teamviewer    Installa TeamViewer ^(italiano^)
echo   -v, --vscode        Installa Visual Studio Code
echo   -w, --winutil       Esegue Chris Titus Tech WinUtil
echo   -h, --help          Mostra questo aiuto
echo.
echo LOGICA INSTALLAZIONE:
echo   • SENZA parametri: Installa SOLO software base
echo   • CON parametri:   Installa SOLO software opzionali specificati ^(NO base^)
echo.
echo SOFTWARE BASE ^(solo senza parametri^):
echo   7-Zip, Adobe Reader IT, Google Chrome IT, Speccy
echo   LibreOffice IT, Supremo Remote Desktop
echo.
echo SOFTWARE OPZIONALI ^(solo con parametri^):
echo   PowerShell, Veeam Agent, Firefox IT, Thunderbird IT
echo   Notepad++ IT, TeamViewer IT, Visual Studio Code
echo.
echo ESEMPI:
echo   %SCRIPT_FULLNAME%                    - Tutto e solo software base
echo   %SCRIPT_FULLNAME% -p -b -f           - Solo PowerShell + Veeam + Firefox
echo   %SCRIPT_FULLNAME% -n -t -v           - Solo Notepad++ + TeamViewer + VS Code
echo   %SCRIPT_FULLNAME% -f -r              - Solo Firefox + Thunderbird
echo   %SCRIPT_FULLNAME% -w                 - Esegui Chris Titus Tech WinUtil
echo   %SCRIPT_FULLNAME% -h                 - Visualizza questa guida
echo.
goto EOF

:RUN_WINUTIL
echo Avvio WinUtil...
powershell -Command "irm https://christitus.com/win | iex"
if %errorlevel% equ 0 (
    echo.
    echo ✓ WinUtil eseguito
    echo.
) else (
    echo.
    echo ✗ ERRORE: Impossibile eseguire WinUtil
    echo.
    pause
)
goto EOF

:CHECK_WINGET
echo [%time%] Verifica Winget... >> "%logfile%"
winget --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [%time%] ✓ Winget trovato >> "%logfile%"
    goto UPDATE_PACKAGES
) else (
    echo [%time%] ✗ Winget non disponibile >> "%logfile%"
    echo [%time%] ERRORE: Impossibile procedere senza Winget >> "%logfile%"
    echo.
    echo ✗ ERRORE: Impossibile procedere senza Winget
    echo.
    pause
    goto EOF
)

:UPDATE_PACKAGES
echo [%time%] Aggiornamento pacchetti... >> "%logfile%"
echo Aggiornamento pacchetti winget in corso...
winget update --all --include-unknown --accept-package-agreements --accept-source-agreements
if %errorlevel% equ 0 (
    echo [%time%] ✓ Aggiornamento completato >> "%logfile%"
) else (
    echo [%time%] ✗ Errore aggiornamento >> "%logfile%"
)

REM Installa in base ai parametri
if !INSTALL_ONLY_BASE!==1 (
    goto INSTALL_BASE
) else (
    goto INSTALL_OPTIONAL
)

:INSTALL_BASE
echo [%time%] INSTALLAZIONE SOFTWARE BASE... >> "%logfile%"
echo.
echo INSTALLAZIONE SOFTWARE BASE...

REM 7-Zip
echo [%time%] Installando 7-Zip... >> "%logfile%"
echo Installando 7-Zip...
winget install -h --id 7zip.7zip --accept-package-agreements --accept-source-agreements
if %errorlevel% equ 0 (echo [%time%] ✓ 7-Zip installato >> "%logfile%") else (echo [%time%] ✗ Errore installazione 7-Zip >> "%logfile%")

REM Adobe Reader IT
echo [%time%] Installando Adobe Reader IT... >> "%logfile%"
echo Installando Adobe Reader IT...
winget install -h --id Adobe.Acrobat.Reader.64-bit --accept-package-agreements --accept-source-agreements
if %errorlevel% equ 0 (echo [%time%] ✓ Adobe Reader installato >> "%logfile%") else (echo [%time%] ✗ Errore installazione Adobe Reader >> "%logfile%")

REM Google Chrome IT
echo [%time%] Installando Google Chrome IT... >> "%logfile%"
echo Installando Google Chrome IT...
winget install -h --id Google.Chrome --accept-package-agreements --accept-source-agreements
if %errorlevel% equ 0 (echo [%time%] ✓ Google Chrome installato >> "%logfile%") else (echo [%time%] ✗ Errore installazione Google Chrome >> "%logfile%")

REM Speccy
echo [%time%] Installando Speccy... >> "%logfile%"
echo Installando Speccy...
winget install -h --id Piriform.Speccy --accept-package-agreements --accept-source-agreements
if %errorlevel% equ 0 (
    echo [%time%] ✓ Speccy installato >> "%logfile%"
    echo [%time%] Generazione report Speccy... >> "%logfile%"
    echo Generazione report Speccy...
    set "COMPUTERNAME=%COMPUTERNAME%"
    
    REM Usa lo stesso formato per il report Speccy
    for /f "tokens=1-3 delims=/" %%a in ('date /t') do (
        set "report_year=%%c"
        set "report_month=%%a"
        set "report_day=%%b"
    )
    for /f "tokens=1-2 delims=:" %%a in ('time /t') do (
        set "report_hour=%%a"
        set "report_minute=%%b"
    )
    
    REM Rimuove tutti gli spazi
    set "report_year=!report_year: =!"
    set "report_month=!report_month: =!"
    set "report_day=!report_day: =!"
    set "report_hour=!report_hour: =!"
    set "report_minute=!report_minute: =!"
    
    REM Aggiunge zero davanti ai numeri singoli (dopo aver rimosso gli spazi)
    if "!report_month!" lss "10" set "report_month=0!report_month!"
    if "!report_day!" lss "10" set "report_day=0!report_day!"
    if "!report_hour!" lss "10" set "report_hour=0!report_hour!"
    if "!report_minute!" lss "10" set "report_minute=0!report_minute!"
    
    set "reportfile=Speccy_Report_%COMPUTERNAME%_!report_year!-!report_month!-!report_day!_!report_hour!-!report_minute!.txt"
    "C:\Program Files\Speccy\Speccy.exe" /silent /report_txt:"%USERPROFILE%\Desktop\%reportfile%"
    if exist "%USERPROFILE%\Desktop\%reportfile%" (
        echo [%time%] ✓ Report Speccy creato >> "%logfile%"
    ) else (
        echo [%time%] ✗ Report Speccy non creato >> "%logfile%"
    )
) else (
    echo [%time%] ✗ Errore installazione Speccy >> "%logfile%"
)

REM LibreOffice IT
echo [%time%] Installando LibreOffice IT... >> "%logfile%"
echo Installando LibreOffice IT...
winget install -h --id TheDocumentFoundation.LibreOffice --accept-package-agreements --accept-source-agreements
if %errorlevel% equ 0 (echo [%time%] ✓ LibreOffice installato >> "%logfile%") else (echo [%time%] ✗ Errore installazione LibreOffice >> "%logfile%")

REM Supremo Remote Desktop
echo [%time%] Download Supremo... >> "%logfile%"
echo Download Supremo...
powershell -Command "Invoke-WebRequest -Uri 'https://www.nanosystems.it/public/download/Supremo.exe' -OutFile '%USERPROFILE%\Desktop\Supremo.exe'"
if exist "%USERPROFILE%\Desktop\Supremo.exe" (
    echo [%time%] ✓ Supremo scaricato >> "%logfile%"
) else (
    echo [%time%] ✗ Download Supremo fallito >> "%logfile%"
)

goto CREATE_WINUTIL

:INSTALL_OPTIONAL
echo [%time%] INSTALLAZIONE SOFTWARE OPZIONALI... >> "%logfile%"
echo.
echo INSTALLAZIONE SOFTWARE OPZIONALI...

if !INSTALL_POWERSHELL!==1 (
    echo [%time%] Installando PowerShell... >> "%logfile%"
    echo Installando PowerShell...
    winget install -h --id Microsoft.PowerShell -e --accept-package-agreements --accept-source-agreements
    if %errorlevel% equ 0 (echo [%time%] ✓ PowerShell installato >> "%logfile%") else (echo [%time%] ✗ Errore installazione PowerShell >> "%logfile%")
)

if !INSTALL_VEEAM!==1 (
    echo [%time%] Installando Veeam Agent... >> "%logfile%"
    echo Installando Veeam Agent...
    winget install -h --id Veeam.VeeamAgent -e --accept-package-agreements --accept-source-agreements
    if %errorlevel% equ 0 (echo [%time%] ✓ Veeam Agent installato >> "%logfile%") else (echo [%time%] ✗ Errore installazione Veeam Agent >> "%logfile%")
)

if !INSTALL_FIREFOX!==1 (
    echo [%time%] Installando Firefox IT... >> "%logfile%"
    echo Installando Firefox IT...
    winget install -h --id Mozilla.Firefox.it -e --accept-package-agreements --accept-source-agreements
    if %errorlevel% equ 0 (echo [%time%] ✓ Firefox installato >> "%logfile%") else (echo [%time%] ✗ Errore installazione Firefox >> "%logfile%")
)

if !INSTALL_THUNDERBIRD!==1 (
    echo [%time%] Installando Thunderbird IT... >> "%logfile%"
    echo Installando Thunderbird IT...
    winget install -h --id Mozilla.Thunderbird.it -e --accept-package-agreements --accept-source-agreements
    if %errorlevel% equ 0 (echo [%time%] ✓ Thunderbird installato >> "%logfile%") else (echo [%time%] ✗ Errore installazione Thunderbird >> "%logfile%")
)

if !INSTALL_NOTEPAD!==1 (
    echo [%time%] Installando Notepad++ IT... >> "%logfile%"
    echo Installando Notepad++ IT...
    winget install -h --id Notepad++.Notepad++ -e --accept-package-agreements --accept-source-agreements
    if %errorlevel% equ 0 (echo [%time%] ✓ Notepad++ installato >> "%logfile%") else (echo [%time%] ✗ Errore installazione Notepad++ >> "%logfile%")
)

if !INSTALL_TEAMVIEWER!==1 (
    echo [%time%] Installando TeamViewer IT... >> "%logfile%"
    echo Installando TeamViewer IT...
    winget install -h --id TeamViewer.TeamViewer -e --accept-package-agreements --accept-source-agreements
    if %errorlevel% equ 0 (echo [%time%] ✓ TeamViewer installato >> "%logfile%") else (echo [%time%] ✗ Errore installazione TeamViewer >> "%logfile%")
)

if !INSTALL_VSCODE!==1 (
    echo [%time%] Installando Visual Studio Code... >> "%logfile%"
    echo Installando Visual Studio Code...
    winget install -h --id Microsoft.VisualStudioCode -e --accept-package-agreements --accept-source-agreements
    if %errorlevel% equ 0 (echo [%time%] ✓ VS Code installato >> "%logfile%") else (echo [%time%] ✗ Errore installazione VS Code >> "%logfile%")
)

:CREATE_WINUTIL
@rem TEMPORARILY DISABLED AS IT DOESN'T WORK
@rem echo [%time%] Creazione collegamento WinUtil... >> "%logfile%"
@rem echo Creazione collegamento WinUtil...
@rem powershell -WindowStyle Hidden -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%APPDATA%\Microsoft\Windows\Start Menu\Programs\WinUtil.lnk'); $Shortcut.TargetPath = 'powershell.exe'; $Shortcut.Arguments = '-NoExit -Command \"irm https://christitus.com/win | iex\"'; $Shortcut.WorkingDirectory = '%USERPROFILE%'; $Shortcut.Save()"
@rem if %errorlevel% equ 0 (
@rem     echo [%time%] ✓ Collegamento WinUtil creato >> "%logfile%"
@rem ) else (
@rem     echo [%time%] ✗ Errore creazione collegamento WinUtil >> "%logfile%"
@rem )

:COMPLETED
echo. >> "%logfile%"
echo ====================================================================== >> "%logfile%"
echo [%time%] INSTALLAZIONE COMPLETATA >> "%logfile%"
echo ====================================================================== >> "%logfile%"

echo.
echo ======================================================================
echo %SCRIPT_NAME% v%SCRIPT_VERSION% - INSTALLAZIONE COMPLETATA
echo ======================================================================
echo.
if !INSTALL_ONLY_BASE!==1 (
    echo ✓ Software base installati
    @rem ATTUALMENTE IL REPORT NON VIENE EFFETTIVAMENTE PRODOTTO...
    @rem echo ✓ Report Speccy generato sul Desktop
    echo ✓ Supremo scaricato sul Desktop
    @rem echo ✓ Collegamento WinUtil creato nel Menu Start
) else (
    echo ✓ Software opzionali installati
)
echo.
echo 📄 Log completo: %logfile%
echo.

:EOF
endlocal