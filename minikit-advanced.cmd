@echo off
setlocal EnableDelayedExpansion

set installVeeam=false
set runWinUtil=false

REM Analizza tutti i parametri
for %%p in (%*) do (
    if /I "%%p"=="/b" set installVeeam=true
    if /I "%%p"=="/t" set runWinUtil=true
)

REM Verifica se winget è disponibile
winget --version >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
     echo Winget è già installato. Avvio aggiornamento...
     winget update --all --include-unknown
	 echo Avvio installazione minikit...
	 winget install 7zip.7zip
	 winget install Adobe.Acrobat.Reader.64-bit
	 winget install Google.Chrome
	 winget install Microsoft.PowerShell
	 winget install Piriform.Speccy
	 winget install TheDocumentFoundation.LibreOffice
    if "!installVeeam!"=="true" (
        echo Installazione di Veeam Agent in corso...
        winget install --id Veeam.VeeamAgent -e --accept-package-agreements --accept-source-agreements
    )
) ELSE (
    echo Winget non è installato. Provo ad installarlo...
    powershell -Command "Start-Process powershell -ArgumentList 'Invoke-WebRequest https://aka.ms/getwinget -OutFile winget-install.ps1; powershell -ExecutionPolicy Bypass -File winget-install.ps1' -Verb RunAs" >nul 2>&1
    timeout /t 10 >nul
    winget --version >nul 2>&1
    IF %ERRORLEVEL% EQU 0 (
        echo Winget installato con successo.
        if "!installVeeam!"=="true" (
            winget install --id Veeam.VeeamAgent -e --accept-package-agreements --accept-source-agreements
        ) else (
            winget upgrade --all
        )
    ) ELSE (
        echo Impossibile installare Winget. Apro lo Store...
        for /f "tokens=3 delims= " %%a in ('reg query "HKCU\Control Panel\International" /v LocaleName 2^>nul') do set locale=%%a
        if not defined locale set locale=en-US
        start https://apps.microsoft.com/store/detail/app-installer/9NBLGGH4NNS1?hl=%locale%
    )
)

REM Creazione collegamento nel Menu Start utente (sovrascrive se già esiste)
set shortcutName=WinUtil - Chris Titus Tech
set startMenuPath=%APPDATA%\Microsoft\Windows\Start Menu\Programs
set shortcutFullPath=%startMenuPath%\%shortcutName%.lnk

powershell -NoProfile -Command ^
"$s=(New-Object -COM WScript.Shell).CreateShortcut('%shortcutFullPath%'); ^
$s.TargetPath='powershell.exe'; ^
$s.Arguments='-NoExit -Command "& { irm https://christitus.com/win | iex }"'; ^
$s.WorkingDirectory='%USERPROFILE%'; ^
$s.WindowStyle=7; ^
$s.IconLocation='powershell.exe'; ^
$s.Save()"
echo Collegamento a WinUtil aggiornato nel Menu Start ✔️

REM Esecuzione dello script WinUtil se richiesto
if "!runWinUtil!"=="true" (
    echo Avvio Chris Titus Tech WinUtil...
    powershell -Command "Start-Process powershell -ArgumentList 'irm https://christitus.com/win | iex' -Verb RunAs"
)

pause