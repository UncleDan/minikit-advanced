@echo off
setlocal enabledelayedexpansion

::                         kkkkkkkk                           
::                         k::::::k                           
::                         k::::::k                           
::                         k::::::k                           
::    mmmmmmm    mmmmmmm    k:::::k    kkkkkkkaaaaaaaaaaaaa   
::  mm:::::::m  m:::::::mm  k:::::k   k:::::k a::::::::::::a  
:: m::::::::::mm::::::::::m k:::::k  k:::::k  aaaaaaaaa:::::a 
:: m::::::::::::::::::::::m k:::::k k:::::k            a::::a 
:: m:::::mmm::::::mmm:::::m k::::::k:::::k      aaaaaaa:::::a 
:: m::::m   m::::m   m::::m k:::::::::::k     aa::::::::::::a 
:: m::::m   m::::m   m::::m k:::::::::::k    a::::aaaa::::::a               _       _        _    _ _               _                               _ 
:: m::::m   m::::m   m::::m k::::::k:::::k  a::::a    a:::::a              (_)     (_)      | |  (_) |             | |                             | |
:: m::::m   m::::m   m::::mk::::::k k:::::k a::::a    a:::::a     _ __ ___  _ _ __  _ ______| | ___| |_    __ _  __| |_   ____ _ _ __   ___ ___  __| |
:: m::::m   m::::m   m::::mk::::::k  k:::::ka:::::aaaa::::::a    | '_ ` _ \| | '_ \| |______| |/ / | __|  / _` |/ _` \ \ / / _` | '_ \ / __/ _ \/ _` |
:: m::::m   m::::m   m::::mk::::::k   k:::::ka::::::::::aa:::a   | | | | | | | | | | |      |   <| | |_  | (_| | (_| |\ V / (_| | | | | (_|  __/ (_| |
:: mmmmmm   mmmmmm   mmmmmmkkkkkkkk    kkkkkkkaaaaaaaaaa  aaaa   |_| |_| |_|_|_| |_|_|      |_|\_\_|\__|  \__,_|\__,_| \_/ \__,_|_| |_|\___\___|\__,_|
::                                                            

::      _           _                 _   _                 
::     | |         | |               | | (_)                
::   __| | ___  ___| | __ _ _ __ __ _| |_ _  ___  _ __  ___ 
::  / _` |/ _ \/ __| |/ _` | '__/ _` | __| |/ _ \| '_ \/ __|
:: | (_| |  __/ (__| | (_| | | | (_| | |_| | (_) | | | \__ \
::  \__,_|\___|\___|_|\__,_|_|  \__,_|\__|_|\___/|_| |_|___/
::                                                          


set "SCRIPT_NAME=Mini-Kit Advanced"
set "SCRIPT_AUTHOR=Daniele Lolli (UncleDan)"
set "SCRIPT_VERSION=26.01"

REM Ottiene il nome completo del file in esecuzione e il percorso
set "SCRIPT_FULLNAME=%~nx0"
set "SCRIPT_NAME_NOEXT=%~n0"
set "SCRIPT_PATH=%~dp0"

::                  _       
::                 (_)      
::  _ __ ___   __ _ _ _ __  
:: | '_ ` _ \ / _` | | '_ \ 
:: | | | | | | (_| | | | | |
:: |_| |_| |_|\__,_|_|_| |_|
::                          

if "%~1"=="" call :SHOW_HELP & goto :EOF

:: Exclusive parameters
for %%a in (%*) do (

    if /i "%%~a"=="-h" call :SHOW_HELP & goto :EOF
    if /i "%%~a"=="--help" call :SHOW_HELP & goto :EOF

    if /i "%%~a"=="-w" call :RUN_WINUTIL & goto :EOF
    if /i "%%~a"=="--winutil" call :RUN_WINUTIL & goto :EOF
    
)

call :INIT_LOGFILE

:: Full parameters check (if not exclusive)
for %%a in (%*) do (

    if /i "%%~a"=="-7" call :WINGET_INSTALL "7-Zip" "7zip.7zip"
    if /i "%%~a"=="--7zip" call :WINGET_INSTALL "7-Zip" "7zip.7zip"
    
)

goto EOF

:: *** salto tutto il codice da qui perché non serve più ***

goto CHECK_WINGET


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

::   __                  _   _                 
::  / _|                | | (_)                
:: | |_ _   _ _ __   ___| |_ _  ___  _ __  ___ 
:: |  _| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
:: | | | |_| | | | | (__| |_| | (_) | | | \__ \
:: |_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
::                                             

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: Show help function - BEGIN
:SHOW_HELP
setlocal
cls
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
echo.
echo Il KIT comprende ^(solo senza parametri^):
echo   7-Zip, Adobe Reader IT, Google Chrome IT, Speccy,
echo   LibreOffice IT, Supremo Remote Desktop
echo.
echo ESEMPI:
echo   %SCRIPT_FULLNAME%                    - Visualizza questo aiuto
echo   %SCRIPT_FULLNAME% -h                 - Visualizza questa guida
echo   %SCRIPT_FULLNAME% -k                 - Installa il kit di software base
echo   %SCRIPT_FULLNAME% --backup           - Installa Veeam Backup Agent
echo   %SCRIPT_FULLNAME% -n -t -v           - Installa Notepad++ + TeamViewer + VS Code
echo   %SCRIPT_FULLNAME% -f -r              - Installa Firefox + Thunderbird
echo   %SCRIPT_FULLNAME% -w                 - Esegui Chris Titus Tech WinUtil
echo.
endlocal & exit /b 1
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: Show help function - END

::::::::::::::::::::::::::::::::::::::::::::::::::::: Run Chrs Titus Tech WinUtil - BEGIN
:RUN_WINUTIL
setlocal
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
endlocal & exit /b 1
::::::::::::::::::::::::::::::::::::::::::::::::::::::: Run Chrs Titus Tech WinUtil - END

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: Init log file funcion - BEGIN
:: !!! ATTENZIONE !!! controllare senza setlocal funziona o va messo nel main script prima di tutto

:INIT_LOGFILE
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

@rem cls
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

echo [%time%] Inizio installazione... >> "%logfile%
echo. >> "%logfile%"
)
exit /b 1
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: Init log file funcion - END

::::::::::::::::::::::::::::::::::::::::::::::::::::::::: Winget install function - BEGIN
:WINGET_INSTALL
setlocal
set "software_name=%~1"
set "id_file=%~2"

:: CONTROLLO 1: Verifica parametri obbligatori
if "%~2"=="" (
    :: [ERRORE] Parametri insufficienti!
    :: Utilizzo: call :WINGET_INSTALL "NomeSoftware" "ID/File"
    ::
    :: Esempio:
    ::   call :WINGET_INSTALL "7zip" "7zip.7zip"
    goto :ERROR_EXIT
)

echo [%time%] Installazione %software_name% >> "%logfile%"
echo Installazione %software_name% in corso...
winget install -h --id Microsoft.PowerShell -e --accept-package-agreements --accept-source-agreements
if %errorlevel% equ 0 (
    echo [%time%] ✓ %software_name% installato >> "%logfile%"
) else (
    echo [%time%] ✗ Errore installazione %software_name% >> "%logfile%"
)

echo.
endlocal & exit /b 1
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: Winget install function - END

:EOF
::                 _              __         __ _ _      
::                | |            / _|       / _(_) |     
::   ___ _ __   __| |______ ___ | |_ ______| |_ _| | ___ 
::  / _ \ '_ \ / _` |______/ _ \|  _|______|  _| | |/ _ \
:: |  __/ | | | (_| |     | (_) | |        | | | | |  __/
::  \___|_| |_|\__,_|      \___/|_|        |_| |_|_|\___|
::                                                       
