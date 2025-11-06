#!/usr/bin/env python3
"""
Mini-Kit Advanced v25.11 by Daniele Lolli (UncleDan)
Script di installazione software per Windows - Modalità Batch Style
"""

import subprocess
import sys
import os
import time
import urllib.request
from pathlib import Path
from datetime import datetime

# Informazioni script
SCRIPT_NAME = "Mini-Kit Advanced"
SCRIPT_AUTHOR = "Daniele Lolli (UncleDan)"
SCRIPT_VERSION = "25.11"

class BatchStyleInstaller:
    def __init__(self):
        self.log_file = f"minikit_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"
        self.winget_available = False
        
        # Software di base (sempre installati)
        self.base_software = {
            "7-Zip": "7zip.7zip",
            "Adobe Reader (IT)": "Adobe.Acrobat.Reader.64-bit",
            "Google Chrome (IT)": "Google.Chrome", 
            "PowerShell": "Microsoft.PowerShell",
            "Speccy": "Piriform.Speccy",
            "LibreOffice (IT)": "TheDocumentFoundation.LibreOffice",
            "Supremo Remote Desktop": "supremo"
        }
        
        # Software opzionale
        self.optional_software = {
            "Veeam Agent": "Veeam.VeeamAgent",
            "Mozilla Firefox (IT)": "Mozilla.Firefox.it",
            "Mozilla Thunderbird (IT)": "Mozilla.Thunderbird.it"
        }
        
        self.print_banner()
    
    def print_banner(self):
        """Stampa il banner iniziale"""
        print("=" * 70)
        print(f"{SCRIPT_NAME} v{SCRIPT_VERSION} - Daniele Lolli (UncleDan)")
        print("=" * 70)
        print("INSTALLAZIONE AUTOMATICA SOFTWARE WINDOWS")
        print("=" * 70)
        print(f"Log: {self.log_file}")
        print()
    
    def log(self, message):
        """Scrive su log e mostra a video"""
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        log_line = f"{timestamp} | {message}"
        print(log_line)
        
        with open(self.log_file, 'a', encoding='utf-8') as f:
            f.write(log_line + '\n')
    
    def run_command(self, command, description=""):
        """Esegue un comando SENZA aprire nuove finestre"""
        if description:
            self.log(f"ESEGUENDO: {description}")
        
        try:
            # Esegue il comando SENZA creare nuove finestre
            process = subprocess.Popen(
                command,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True,
                universal_newlines=True,
                creationflags=subprocess.CREATE_NO_WINDOW  # IMPORTANTE: nessuna nuova finestra!
            )
            
            # Legge l'output in tempo reale
            for line in process.stdout:
                line = line.strip()
                if line:
                    print(f"  {line}")
            
            process.wait()
            
            if process.returncode == 0:
                self.log(f"✓ COMPLETATO: {description}")
                return True
            else:
                self.log(f"✗ ERRORE: {description} (codice: {process.returncode})")
                return False
                
        except Exception as e:
            self.log(f"✗ ECCEZIONE: {description} - {str(e)}")
            return False
    
    def parse_arguments(self):
        """Analizza i parametri da riga di comando"""
        args = sys.argv[1:]
        
        if '-h' in args or '--help' in args or '/?' in args:
            self.show_help()
            return None, None, None, None
        
        backup = '-b' in args or '--backup' in args
        firefox = '-f' in args or '--firefox' in args
        thunderbird = '-r' in args or '--thunderbird' in args
        winutil = '-w' in args or '--winutil' in args
        
        self.log("CONFIGURAZIONE INSTALLAZIONE:")
        self.log(f"  Backup Agent (Veeam): {'SI' if backup else 'NO'}")
        self.log(f"  Firefox: {'SI' if firefox else 'NO'}")
        self.log(f"  Thunderbird: {'SI' if thunderbird else 'NO'}")
        self.log(f"  WinUtil: {'SI' if winutil else 'NO'}")
        self.log("-" * 50)
        
        return backup, firefox, thunderbird, winutil
    
    def show_help(self):
        """Mostra l'help"""
        help_text = f"""
{SCRIPT_NAME} v{SCRIPT_VERSION} - Daniele Lolli (UncleDan)

USO:
    minikit_advanced.exe [OPZIONI]

OPZIONI:
    -b, --backup        Installa Veeam Agent per backup
    -f, --firefox       Installa Mozilla Firefox (italiano)
    -r, --thunderbird   Installa Mozilla Thunderbird (italiano)  
    -w, --winutil       Esegue Chris Titus Tech WinUtil
    -h, --help          Mostra questo aiuto

SOFTWARE BASE (sempre installato):
    7-Zip, Adobe Reader IT, Google Chrome IT, PowerShell
    Speccy, LibreOffice IT, Supremo Remote Desktop

ESEMPI:
    minikit_advanced.exe                    # Solo software base
    minikit_advanced.exe -b -f              # Base + Veeam + Firefox
    minikit_advanced.exe -f -r -w           # Base + Firefox + Thunderbird + WinUtil

NOTA: Per evitare aperture di finestre, eseguire da Prompt dei Comandi.
"""
        print(help_text)
        input("Premere INVIO per uscire...")
        sys.exit(0)
    
    def check_winget(self):
        """Verifica se winget è disponibile"""
        self.log("Verifica Winget...")
        try:
            result = subprocess.run(
                ["winget", "--version"], 
                capture_output=True, 
                text=True, 
                check=True,
                creationflags=subprocess.CREATE_NO_WINDOW  # Nessuna finestra!
            )
            self.winget_available = True
            self.log(f"✓ Winget trovato - Versione: {result.stdout.strip()}")
            return True
        except:
            self.winget_available = False
            self.log("✗ Winget non disponibile")
            return False
    
    def install_winget(self):
        """Tenta di installare winget"""
        self.log("Installazione Winget...")
        try:
            success = self.run_command([
                "powershell", "-WindowStyle", "Hidden", "-Command",
                "Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe"
            ], "Installazione Winget via PowerShell")
            
            time.sleep(5)
            return self.check_winget()
        except Exception as e:
            self.log(f"✗ Errore installazione Winget: {e}")
            return False
    
    def download_supremo(self):
        """Scarica Supremo.exe sul desktop"""
        self.log("Download Supremo...")
        try:
            desktop_path = Path.home() / "Desktop"
            supremo_path = desktop_path / "Supremo.exe"
            
            self.log(f"Scaricando Supremo su: {supremo_path}")
            
            urllib.request.urlretrieve(
                "https://www.nanosystems.it/public/download/Supremo.exe",
                supremo_path
            )
            
            if supremo_path.exists():
                file_size = supremo_path.stat().st_size
                self.log(f"✓ Supremo scaricato ({file_size} bytes)")
                return True
            else:
                self.log("✗ Download Supremo fallito")
                return False
                
        except Exception as e:
            self.log(f"✗ Errore download Supremo: {e}")
            return False
    
    def install_base_software(self):
        """Installa il software di base"""
        self.log("INSTALLAZIONE SOFTWARE BASE...")
        success_count = 0
        
        for name, package_id in self.base_software.items():
            if name == "Supremo Remote Desktop":
                if self.download_supremo():
                    success_count += 1
            else:
                self.log(f"Installando {name}...")
                if self.run_command([
                    "winget", "install", "-h", "--id", package_id,
                    "--accept-package-agreements", "--accept-source-agreements"
                ], f"Installazione {name}"):
                    success_count += 1
        
        self.log(f"Software base installati: {success_count}/{len(self.base_software)}")
        return success_count > 0
    
    def install_optional_software(self, backup, firefox, thunderbird):
        """Installa il software opzionale"""
        optional_to_install = {}
        
        if backup:
            optional_to_install["Veeam Agent"] = self.optional_software["Veeam Agent"]
        if firefox:
            optional_to_install["Mozilla Firefox (IT)"] = self.optional_software["Mozilla Firefox (IT)"]
        if thunderbird:
            optional_to_install["Mozilla Thunderbird (IT)"] = self.optional_software["Mozilla Thunderbird (IT)"]
        
        if not optional_to_install:
            self.log("Nessun software opzionale selezionato")
            return True
        
        self.log("INSTALLAZIONE SOFTWARE OPZIONALE...")
        success_count = 0
        
        for name, package_id in optional_to_install.items():
            self.log(f"Installando {name}...")
            if self.run_command([
                "winget", "install", "-h", "--id", package_id, "-e",
                "--accept-package-agreements", "--accept-source-agreements"
            ], f"Installazione {name}"):
                success_count += 1
        
        self.log(f"Software opzionale installati: {success_count}/{len(optional_to_install)}")
        return success_count > 0
    
    def create_winutil_shortcut(self):
        """Crea collegamento a WinUtil nel Menu Start"""
        self.log("Creazione collegamento WinUtil...")
        try:
            start_menu_path = Path.home() / "AppData" / "Roaming" / "Microsoft" / "Windows" / "Start Menu" / "Programs"
            start_menu_path.mkdir(parents=True, exist_ok=True)
            
            # Crea script PowerShell per il collegamento
            ps_script = f'''
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("{start_menu_path / 'WinUtil.lnk'}")
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-NoExit -Command `"irm https://christitus.com/win | iex`""
$Shortcut.WorkingDirectory = "{Path.home()}"
$Shortcut.Save()
"Collegamento creato"
'''
            
            # Esegue PowerShell SENZA finestra
            result = self.run_command([
                "powershell", "-WindowStyle", "Hidden", "-Command", ps_script
            ], "Creazione collegamento WinUtil")
            
            return result
            
        except Exception as e:
            self.log(f"✗ Errore creazione collegamento: {e}")
            return False
    
    def run_winutil(self):
        """Esegue WinUtil"""
        self.log("Avvio WinUtil...")
        return self.run_command([
            "powershell", "-WindowStyle", "Hidden", "-Command",
            "irm https://christitus.com/win | iex"
        ], "Esecuzione WinUtil")
    
    def install_software(self):
        """Procedura principale di installazione"""
        # Analizza parametri
        params = self.parse_arguments()
        if params[0] is None:  # Help richiesto
            return
        
        backup, firefox, thunderbird, winutil = params
        
        # Verifica Winget
        if not self.check_winget():
            if not self.install_winget():
                self.log("ERRORE: Impossibile procedere senza Winget")
                return False
        
        # Aggiornamento pacchetti
        self.log("Aggiornamento pacchetti...")
        self.run_command(["winget", "update", "--all", "--include-unknown"], "Aggiornamento pacchetti")
        
        # Installazione software
        self.install_base_software()
        self.install_optional_software(backup, firefox, thunderbird)
        
        # Collegamento WinUtil
        self.create_winutil_shortcut()
        
        # Esecuzione WinUtil se richiesto
        if winutil:
            self.run_winutil()
        
        self.log("=" * 70)
        self.log("INSTALLAZIONE COMPLETATA")
        self.log("=" * 70)
        return True

def main():
    """Funzione principale"""
    # Se fatto doppio-click, avvisa l'utente
    if len(sys.argv) == 1 and 'python.exe' in sys.executable:
        print("ATTENZIONE: Doppio-click rilevato!")
        print("Per evitare aperture di finestre, usa il Prompt dei Comandi:")
        print("  minikit_advanced.exe -h  (per help)")
        print()
        input("Premere INVIO per uscire...")
        return 1
    
    installer = BatchStyleInstaller()
    
    try:
        success = installer.install_software()
        
        if success:
            print(f"\n✓ {SCRIPT_NAME} v{SCRIPT_VERSION} - INSTALLAZIONE COMPLETATA")
            print("✓ Tutti i software sono stati installati")
            print("✓ Supremo.exe scaricato sul Desktop")
        else:
            print(f"\n⚠ {SCRIPT_NAME} v{SCRIPT_VERSION} - INSTALLAZIONE CON ERRORI")
        
        print(f"📄 Log completo: {installer.log_file}")
        
    except KeyboardInterrupt:
        print(f"\n⏹ INSTALLAZIONE INTERROTTA")
        print(f"📄 Log: {installer.log_file}")
        return 1
    except Exception as e:
        print(f"\n❌ ERRORE CRITICO: {e}")
        print(f"📄 Log: {installer.log_file}")
        return 1
    
    print("\nPremere INVIO per uscire...")
    input()
    return 0

if __name__ == "__main__":
    sys.exit(main())