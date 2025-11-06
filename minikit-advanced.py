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
        
        # Software di base (installati solo SENZA parametri)
        self.base_software = {
            "7-Zip": "7zip.7zip",
            "Adobe Reader (IT)": "Adobe.Acrobat.Reader.64-bit",
            "Google Chrome (IT)": "Google.Chrome", 
            "PowerShell": "Microsoft.PowerShell",
            "Speccy": "Piriform.Speccy",
            "LibreOffice (IT)": "TheDocumentFoundation.LibreOffice",
            "Supremo Remote Desktop": "supremo"
        }
        
        # Software opzionale (installati solo CON parametri)
        self.optional_software = {
            "Veeam Agent": "Veeam.VeeamAgent",
            "Mozilla Firefox (IT)": "Mozilla.Firefox.it",
            "Mozilla Thunderbird (IT)": "Mozilla.Thunderbird.it",
            "Notepad++ (IT)": "Notepad++.Notepad++",
            "TeamViewer (IT)": "TeamViewer.TeamViewer",
            "Visual Studio Code": "Microsoft.VisualStudioCode"
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
                creationflags=subprocess.CREATE_NO_WINDOW
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
            return None
        
        # Se nessun parametro, installa solo software base
        if not args:
            self.log("NESSUN PARAMETRO: Installazione SOLO software base")
            return "base"
        
        # Altrimenti installa solo i software opzionali specificati
        self.log("PARAMETRI RILEVATI: Installazione SOLO software opzionali specificati")
        
        selected_software = {}
        
        if '-b' in args or '--backup' in args:
            selected_software["Veeam Agent"] = self.optional_software["Veeam Agent"]
        if '-f' in args or '--firefox' in args:
            selected_software["Mozilla Firefox (IT)"] = self.optional_software["Mozilla Firefox (IT)"]
        if '-r' in args or '--thunderbird' in args:
            selected_software["Mozilla Thunderbird (IT)"] = self.optional_software["Mozilla Thunderbird (IT)"]
        if '-n' in args or '--notepad' in args:
            selected_software["Notepad++ (IT)"] = self.optional_software["Notepad++ (IT)"]
        if '-t' in args or '--teamviewer' in args:
            selected_software["TeamViewer (IT)"] = self.optional_software["TeamViewer (IT)"]
        if '-v' in args or '--vscode' in args:
            selected_software["Visual Studio Code"] = self.optional_software["Visual Studio Code"]
        
        winutil = '-w' in args or '--winutil' in args
        
        self.log("CONFIGURAZIONE INSTALLAZIONE:")
        self.log(f"  Software base: NO")
        self.log(f"  Software opzionali selezionati: {len(selected_software)}")
        for name in selected_software.keys():
            self.log(f"    • {name}")
        self.log(f"  WinUtil: {'SI' if winutil else 'NO'}")
        self.log("-" * 50)
        
        return {"software": selected_software, "winutil": winutil}
    
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
    -n, --notepad       Installa Notepad++ (italiano)
    -t, --teamviewer    Installa TeamViewer (italiano)
    -v, --vscode        Installa Visual Studio Code
    -w, --winutil       Esegue Chris Titus Tech WinUtil
    -h, --help          Mostra questo aiuto

LOGICA INSTALLAZIONE:
    • SENZA parametri: Installa SOLO software base
    • CON parametri:   Installa SOLO software opzionali specificati (NO base)

SOFTWARE BASE (solo senza parametri):
    7-Zip, Adobe Reader IT, Google Chrome IT, PowerShell
    Speccy, LibreOffice IT, Supremo Remote Desktop

SOFTWARE OPZIONALI (solo con parametri):
    Veeam Agent, Firefox IT, Thunderbird IT, Notepad++ IT
    TeamViewer IT, Visual Studio Code

ESEMPI:
    minikit_advanced.exe                    # Solo software base
    minikit_advanced.exe -b -f              # Solo Veeam + Firefox (NO base)
    minikit_advanced.exe -n -t -v           # Solo Notepad++ + TeamViewer + VS Code
    minikit_advanced.exe -f -r -w           # Solo Firefox + Thunderbird + WinUtil

NOTA: Per evitare aperture di finestre, eseguire da Prompt dei Comandi.
"""
        print(help_text)
        return
    
    def check_winget(self):
        """Verifica se winget è disponibile"""
        self.log("Verifica Winget...")
        try:
            result = subprocess.run(
                ["winget", "--version"], 
                capture_output=True, 
                text=True, 
                check=True,
                creationflags=subprocess.CREATE_NO_WINDOW
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
    
    def run_speccy_report(self):
        """Esegue Speccy in modalità silent per generare report"""
        self.log("Generazione report Speccy...")
        try:
            # Ottiene il nome del computer
            computer_name = os.environ.get('COMPUTERNAME', 'UnknownPC')
            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
            
            # Crea il nome del file report
            report_filename = f"Speccy_Report_{computer_name}_{timestamp}.txt"
            desktop_path = Path.home() / "Desktop"
            report_path = desktop_path / report_filename
            
            self.log(f"Creazione report: {report_path}")
            
            # Esegue Speccy in modalità silent per generare il report
            success = self.run_command([
                "speccy.exe", "/silent", report_path
            ], f"Generazione report Speccy: {report_filename}")
            
            if success:
                # Verifica che il file sia stato creato
                if report_path.exists():
                    file_size = report_path.stat().st_size
                    self.log(f"✓ Report Speccy creato ({file_size} bytes)")
                    return True
                else:
                    self.log("✗ Report Speccy non creato")
                    return False
            else:
                self.log("✗ Errore nell'esecuzione di Speccy")
                return False
                
        except Exception as e:
            self.log(f"✗ Errore generazione report Speccy: {e}")
            return False
    
    def install_base_software(self):
        """Installa il software di base"""
        self.log("INSTALLAZIONE SOFTWARE BASE...")
        success_count = 0
        speccy_installed = False
        
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
                    # Segna se Speccy è stato installato con successo
                    if name == "Speccy":
                        speccy_installed = True
        
        # Se Speccy è stato installato con successo, genera il report
        if speccy_installed:
            self.log("Speccy installato con successo - generazione report...")
            time.sleep(2)  # Attende che l'installazione sia completata
            self.run_speccy_report()
        
        self.log(f"Software base installati: {success_count}/{len(self.base_software)}")
        return success_count > 0
    
    def install_optional_software(self, selected_software):
        """Installa il software opzionale specificato"""
        if not selected_software:
            self.log("Nessun software opzionale selezionato")
            return True
        
        self.log("INSTALLAZIONE SOFTWARE OPZIONALI...")
        success_count = 0
        
        for name, package_id in selected_software.items():
            self.log(f"Installando {name}...")
            if self.run_command([
                "winget", "install", "-h", "--id", package_id, "-e",
                "--accept-package-agreements", "--accept-source-agreements"
            ], f"Installazione {name}"):
                success_count += 1
        
        self.log(f"Software opzionali installati: {success_count}/{len(selected_software)}")
        return success_count > 0
    
    def update_winget_packages(self):
        """Aggiorna i pacchetti winget"""
        self.log("Aggiornamento pacchetti...")
        return self.run_command([
            "winget", "update", "--all", "--include-unknown"
        ], "Aggiornamento pacchetti winget")
    
    def create_winutil_shortcut(self):
        """Crea collegamento a WinUtil nel Menu Start"""
        self.log("Creazione collegamento WinUtil...")
        try:
            start_menu_path = Path.home() / "AppData" / "Roaming" / "Microsoft" / "Windows" / "Start Menu" / "Programs"
            start_menu_path.mkdir(parents=True, exist_ok=True)
            
            ps_script = f'''
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("{start_menu_path / 'WinUtil.lnk'}")
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-NoExit -Command `"irm https://christitus.com/win | iex`""
$Shortcut.WorkingDirectory = "{Path.home()}"
$Shortcut.Save()
"Collegamento creato"
'''
            
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
        if params is None:  # Help richiesto
            return False
        
        # Verifica Winget
        if not self.check_winget():
            if not self.install_winget():
                self.log("ERRORE: Impossibile procedere senza Winget")
                return False
        
        # Aggiornamento pacchetti
        self.update_winget_packages()
        
        # Installazione in base ai parametri
        if params == "base":
            # Solo software base
            self.install_base_software()
        else:
            # Solo software opzionali specificati
            self.install_optional_software(params["software"])
            
            # WinUtil se richiesto
            if params["winutil"]:
                self.run_winutil()
        
        # Collegamento WinUtil (sempre creato)
        self.create_winutil_shortcut()
        
        self.log("=" * 70)
        self.log("INSTALLAZIONE COMPLETATA")
        self.log("=" * 70)
        return True

def safe_input(prompt=""):
    """Input sicuro che evita l'errore 'lost sys.stdin'"""
    try:
        return input(prompt)
    except (EOFError, RuntimeError):
        return ""

def main():
    """Funzione principale"""
    # Se fatto doppio-click, avvisa l'utente
    if len(sys.argv) == 1 and 'python.exe' in sys.executable:
        print("ATTENZIONE: Doppio-click rilevato!")
        print("Per evitare aperture di finestre, usa il Prompt dei Comandi:")
        print("  minikit_advanced.exe -h  (per help)")
        print()
        safe_input("Premere INVIO per uscire...")
        return 1
    
    installer = BatchStyleInstaller()
    
    try:
        success = installer.install_software()
        
        if success:
            print(f"\n✓ {SCRIPT_NAME} v{SCRIPT_VERSION} - INSTALLAZIONE COMPLETATA")
            print("✓ Report Speccy generato sul Desktop")
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
    safe_input()
    return 0

if __name__ == "__main__":
    sys.exit(main())