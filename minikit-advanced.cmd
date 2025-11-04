@echo off
setlocal EnableDelayedExpansion

set installVeeam=true
set installFirefox=true
set installThunderbird=true
set runWinUtil=false

REM Analizza tutti i parametri
for %%p in (%*) do (
    if /I "%%p"=="/b" set installVeeam=true
    if /I "%%p"=="/f" set installFirefox=true
    if /I "%%p"=="/t" set installThunderbird=true
    if /I "%%p"=="/w" set runWinUtil=true
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
    if "!installFirefox!"=="true" (
        echo Installazione di Mozilla Firefox in corso...
        winget install --id Mozilla.Firefox.it -e --accept-package-agreements --accept-source-agreements
    if "!installThunderbird!"=="true" (
        echo Installazione di Mozilla Thunderbird in corso...
        winget install --id Mozilla.Thunderbird.it -e --accept-package-agreements --accept-source-agreements
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

@rem REM Creazione collegamento nel Menu Start utente (sovrascrive se già esiste)
@rem set shortcutName=WinUtil - Chris Titus Tech
@rem set startMenuPath=%APPDATA%\Microsoft\Windows\Start Menu\Programs
@rem set shortcutFullPath=%startMenuPath%\%shortcutName%.lnk
@rem 
@rem powershell -NoProfile -Command ^
@rem "$s=(New-Object -COM WScript.Shell).CreateShortcut('%shortcutFullPath%'); ^
@rem $s.TargetPath='powershell.exe'; ^
@rem $s.Arguments='-NoExit -Command "& { irm https://christitus.com/win | iex }"'; ^
@rem $s.WorkingDirectory='%USERPROFILE%'; ^
@rem $s.WindowStyle=7; ^
@rem $s.IconLocation='powershell.exe'; ^
@rem $s.Save()"
@rem echo Collegamento a WinUtil aggiornato nel Menu Start ✔️

REM Esecuzione dello script WinUtil se richiesto
if "!runWinUtil!"=="true" (
    echo Avvio Chris Titus Tech WinUtil...
    powershell -Command "Start-Process powershell -ArgumentList 'irm https://christitus.com/win | iex' -Verb RunAs"
)

pause