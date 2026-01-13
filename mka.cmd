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

    if /i "%%~a"=="-k" call :INSTALL_KIT & goto :EOF
    if /i "%%~a"=="--kit" call :INSTALL_KIT & goto :EOF

)

call :INIT_LOGFILE

:: Full parameters check (if not exclusive)
for %%a in (%*) do (

    if /i "%%~a"=="-7" (
        call :WINGET_INSTALL "7-Zip" "7zip.7zip"
    ) else if /i "%%~a"=="--7zip" (
        call :WINGET_INSTALL "7-Zip" "7zip.7zip"
    ) else if /i "%%~a"=="-a" (
        call :WINGET_INSTALL "Adobe Reader" "Adobe.Acrobat.Reader.64-bit"
    ) else if /i "%%~a"=="--adobereader" (
        call :WINGET_INSTALL "Adobe Reader" "Adobe.Acrobat.Reader.64-bit"
    ) else if /i "%%~a"=="-c" (
        call :WINGET_INSTALL "Google Chrome" "Google.Chrome"
    ) else if /i "%%~a"=="--chrome" (
        call :WINGET_INSTALL "Google Chrome" "Google.Chrome"
    ) else if /i "%%~a"=="-l" (
        call :WINGET_INSTALL "Libre Office" "TheDocumentFoundation.LibreOffice"
    ) else if /i "%%~a"=="--libreoffice" (
        call :WINGET_INSTALL "Libre Office" "TheDocumentFoundation.LibreOffice"
    ) else if /i "%%~a"=="-s" (
        call :WINGET_INSTALL "Speccy" "Piriform.Speccy"
    ) else if /i "%%~a"=="--speccy" (
        call :WINGET_INSTALL "Speccy" "Piriform.Speccy"
    ) else if /i "%%~a"=="-u" (
        call :DOWNLOAD_ON_DESKTOP "Supremo" "https://www.nanosystems.it/public/download/Supremo.exe"
    ) else if /i "%%~a"=="--speccy" (
        call :WINGET_INSTALL "Speccy" "Piriform.Speccy"
    ) else if /i "%%~a"=="-b" (
        call :WINGET_INSTALL "Veeam Agent for Microsoft Windows" "Veeam.VeeamAgent"
    ) else if /i "%%~a"=="--backup" (
        call :WINGET_INSTALL "Veeam Agent for Microsoft Windows" "Veeam.VeeamAgent"
    ) else if /i "%%~a"=="-f" (
        call :WINGET_INSTALL "Firefox IT" "Mozilla.Firefox.it"
    ) else if /i "%%~a"=="--firefox" (
        call :WINGET_INSTALL "Firefox IT" "Mozilla.Firefox.it"
    ) else if /i "%%~a"=="-n" (
        call :WINGET_INSTALL "Notepad++" "Notepad++.Notepad++"
    ) else if /i "%%~a"=="--notepad" (
        call :WINGET_INSTALL "Notepad++" "Notepad++.Notepad++"
    ) else if /i "%%~a"=="-p" (
        call :WINGET_INSTALL "PowerShell" "Microsoft.PowerShell"
    ) else if /i "%%~a"=="--powershell" (
        call :WINGET_INSTALL "PowerShell" "Microsoft.PowerShell"
    ) else if /i "%%~a"=="-r" (
        call :WINGET_INSTALL "Thunderbird IT" "Mozilla.Thunderbird.it"
    ) else if /i "%%~a"=="--thunderbird" (
        call :WINGET_INSTALL "Thunderbird IT" "Mozilla.Thunderbird.it"
    ) else if /i "%%~a"=="-t" (
        call :WINGET_INSTALL "TeamViewer" "TeamViewer.TeamViewer"
    ) else if /i "%%~a"=="--teamviewer" (
        call :WINGET_INSTALL "TeamViewer" "TeamViewer.TeamViewer"
    ) else if /i "%%~a"=="-c" (
        call :WINGET_INSTALL "Visual Studio Code" "Microsoft.VisualStudioCode"
    ) else if /i "%%~a"=="--vscode" (
        call :WINGET_INSTALL "Visual Studio Code" "Microsoft.VisualStudioCode"
    ) else (
        echo [%time%] Parametro non riconosciuto: %%~a >> "%logfile%"
        echo.
        echo ✗ AVVISO: Parametro non riconosciuto %%~a
        echo.
    )
    
)

goto EOF

:: *** salto tutto il codice da qui perché non serve più ***

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
echo   -k, --kit    Installa kit base
echo.
echo Il kit base comprende l'installazione automatica del seguente software:
echo   7-Zip, Adobe Reader IT, Google Chrome IT, Speccy,
echo   LibreOffice IT, Supremo Remote Desktop
echo.
echo   -7, --7zip          Installa 7-Zip
echo   -a, --adobereader   Installa Adobe Acrobat Reader IT
echo   -c, --chrome        Installa Google Chrome IT
echo   -l, --libreoffice   Installa LibreOffice IT
echo   -s, --speccy        Installa Speccy
echo   -u, --supremo       Scarica Supremo Remote Desktop sul Desktop
echo.
echo   -b, --backup        Installa Veeam Agent per backup
echo   -f, --firefox       Installa Mozilla Firefox ^(italiano^)
echo   -n, --notepad       Installa Notepad++ ^(italiano^)
echo   -p, --powershell    Installa PowerShell
echo   -r, --thunderbird   Installa Mozilla Thunderbird ^(italiano^)
echo   -t, --teamviewer    Installa TeamViewer ^(italiano^)
echo   -v, --vscode        Installa Visual Studio Code
echo.
echo   -w, --winutil       Esegue Chris Titus Tech WinUtil
echo   -h, --help          Mostra questo aiuto
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

:::::::::::::::::::::::::::::::::::::::::::::::::::: Download on Desktop function - BEGIN
:DOWNLOAD_ON_DESKTOP
setlocal
set "software_name=%~1"
set "download_url=%~2"

if "%~2"=="" (
    :: [ERRORE] Parametri insufficienti!
    :: Utilizzo: call :DOWNLOAD_ON_DESKTOP "NomeSoftware" "URL"
    ::
    :: Esempio:
    ::   call :DOWNLOAD_ON_DESKTOP "Supremo" "https://www.nanosystems.it/public/download/Supremo.exe"
    goto :ERROR_EXIT
)

echo [%time%] Download %software_name% >> "%logfile%"
echo Download %software_name% in corso...
powershell -Command "Invoke-WebRequest -Uri '%download_url%' -OutFile '%USERPROFILE%\Desktop\%software_name%.exe'"
if %errorlevel% equ 0 (
    echo [%time%] ✓ %software_name% scaricato >> "%logfile%"
) else (
    echo [%time%] ✗ Errore download %software_name% >> "%logfile%"
)

echo.
endlocal & exit /b 1
:::::::::::::::::::::::::::::::::::::::::::::::::::::: Download on Desktop function - END

::::::::::::::::::::::::::::::::::::::::::::: Download on public Desktop function - BEGIN
:DOWNLOAD_ON_PUBLIC_DESKTOP
setlocal
set "software_name=%~1"
set "download_url=%~2"

if "%~2"=="" (
    :: [ERRORE] Parametri insufficienti!
    :: Utilizzo: call :DOWNLOAD_ON_PUBLIC_DESKTOP "NomeSoftware" "URL"
    ::
    :: Esempio:
    ::   call :DOWNLOAD_ON_PUBLIC_DESKTOP "Supremo" "https://www.nanosystems.it/public/download/Supremo.exe"
    goto :ERROR_EXIT
)

echo [%time%] Download %software_name% >> "%logfile%"
echo Download %software_name% in corso...
powershell -Command "Invoke-WebRequest -Uri '%download_url%' -OutFile 'C:\Users\Public\Desktop\%software_name%.exe'"
if %errorlevel% equ 0 (
    echo [%time%] ✓ %software_name% scaricato >> "%logfile%"
) else (
    echo [%time%] ✗ Errore download %software_name% >> "%logfile%"
)

echo.
endlocal & exit /b 1
:::::::::::::::::::::::::::::::::::::::::::::::: Download on publicDesktop function - END

:EOF
::                 _              __         __ _ _      
::                | |            / _|       / _(_) |     
::   ___ _ __   __| |______ ___ | |_ ______| |_ _| | ___ 
::  / _ \ '_ \ / _` |______/ _ \|  _|______|  _| | |/ _ \
:: |  __/ | | | (_| |     | (_) | |        | | | | |  __/
::  \___|_| |_|\__,_|      \___/|_|        |_| |_|_|\___|
::                                                       
