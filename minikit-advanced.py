#!/usr/bin/env python3
"""
Script di installazione software automatica per Windows
Con supporto interfaccia grafica, CLI, logging avanzato e localizzazioni italiane
"""

import subprocess
import sys
import os
import time
import winreg
import urllib.request
import logging
from pathlib import Path
from datetime import datetime

# Import per l'interfaccia grafica
try:
    import tkinter as tk
    from tkinter import ttk, messagebox
    GUI_AVAILABLE = True
except ImportError:
    GUI_AVAILABLE = False

class AdvancedLogger:
    """Gestione avanzata del logging"""
    
    def __init__(self):
        self.logger = None
        self.log_file = None
        self.setup_logging()
    
    def setup_logging(self):
        """Configura il sistema di logging"""
        # Crea directory logs se non esiste
        log_dir = Path("logs")
        log_dir.mkdir(exist_ok=True)
        
        # Nome file con timestamp
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        self.log_file = log_dir / f"minikit-advanced_{timestamp}.log"
        
        # Configura logger
        self.logger = logging.getLogger('SoftwareInstaller')
        self.logger.setLevel(logging.DEBUG)
        
        # Formattatore
        formatter = logging.Formatter(
            '%(asctime)s | %(levelname)-8s | %(message)s',
            datefmt='%Y-%m-%d %H:%M:%S'
        )
        
        # Handler per file
        file_handler = logging.FileHandler(self.log_file, encoding='utf-8')
        file_handler.setLevel(logging.DEBUG)
        file_handler.setFormatter(formatter)
        
        # Handler per console
        console_handler = logging.StreamHandler()
        console_handler.setLevel(logging.INFO)
        console_handler.setFormatter(formatter)
        
        # Aggiungi handler al logger
        self.logger.addHandler(file_handler)
        self.logger.addHandler(console_handler)
        
        self.logger.info("=" * 60)
        self.logger.info("MINIKIT ADVANCED INSTALLER - SESSIONE INIZIATA")
        self.logger.info("=" * 60)
        self.logger.info(f"File di log: {self.log_file}")
    
    def log_system_info(self):
        """Registra informazioni sul sistema"""
        try:
            self.logger.info("Raccolta informazioni sistema...")
            
            # Versione Windows
            try:
                result = subprocess.run(
                    ["systeminfo"], 
                    capture_output=True, 
                    text=True, 
                    check=True
                )
                for line in result.stdout.split('\n'):
                    if "OS Name" in line or "OS Version" in line:
                        self.logger.info(f"Sistema: {line.strip()}")
            except:
                self.logger.warning("Impossibile ottenere informazioni di sistema")
            
            # Lingua sistema
            try:
                with winreg.OpenKey(winreg.HKEY_CURRENT_USER, r"Control Panel\International") as key:
                    locale, _ = winreg.QueryValueEx(key, "LocaleName")
                self.logger.info(f"Lingua sistema: {locale}")
            except:
                self.logger.warning("Impossibile rilevare la lingua del sistema")
            
            # Architettura
            arch = "64-bit" if sys.maxsize > 2**32 else "32-bit"
            self.logger.info(f"Architettura Python: {arch}")
            
        except Exception as e:
            self.logger.error(f"Errore raccolta info sistema: {e}")
    
    def log_operation_start(self, operation):
        """Registra l'inizio di un'operazione"""
        self.logger.info(f"[INIZIO] {operation}")
        return time.time()
    
    def log_operation_end(self, operation, start_time, success=True):
        """Registra la fine di un'operazione con durata"""
        duration = time.time() - start_time
        status = "SUCCESSO" if success else "FALLITO"
        self.logger.info(f"[FINE] {operation} - {status} ({duration:.2f}s)")
    
    def log_software_install_attempt(self, software_name, package_id):
        """Registra tentativo di installazione software"""
        self.logger.info(f"Tentativo installazione: {software_name} ({package_id})")
    
    def log_software_install_result(self, software_name, success, output=""):
        """Registra risultato installazione software"""
        status = "INSTALLATO" if success else "FALLITO"
        self.logger.info(f"Risultato installazione {software_name}: {status}")
        if output and not success:
            self.logger.debug(f"Dettagli errore: {output}")
    
    def log_error(self, error_message, exception=None):
        """Registra un errore"""
        self.logger.error(error_message)
        if exception:
            self.logger.debug(f"Eccezione: {str(exception)}", exc_info=True)
    
    def log_warning(self, warning_message):
        """Registra un warning"""
        self.logger.warning(warning_message)
    
    def log_debug(self, debug_message):
        """Registra un messaggio di debug"""
        self.logger.debug(debug_message)
    
    def close_log(self):
        """Chiude la sessione di logging"""
        self.logger.info("=" * 60)
        self.logger.info("MINIKIT ADVANCED INSTALLER - SESSIONE TERMINATA")
        self.logger.info("=" * 60)
        
        # Rimuovi handler per evitare duplicazioni
        for handler in self.logger.handlers[:]:
            handler.close()
            self.logger.removeHandler(handler)

class SoftwareInstaller:
    def __init__(self):
        self.install_veeam = False
        self.install_firefox = False
        self.install_thunderbird = False
        self.run_win_util = False
        
        # Inizializza logger
        self.logger = AdvancedLogger()
        
        # Software di base (sempre installati) - ORIGINALI
        self.base_software = {
            "7-Zip": "7zip.7zip",
            "Adobe Reader (IT)": "Adobe.Acrobat.Reader.64-bit",
            "Google Chrome (IT)": "Google.Chrome", 
            "PowerShell": "Microsoft.PowerShell",
            "Speccy": "Piriform.Speccy",
            "LibreOffice (IT)": "TheDocumentFoundation.LibreOffice"
        }
        
        # Software opzionale - ORIGINALI
        self.optional_software = {
            "Veeam Agent": "Veeam.VeeamAgent",
            "Mozilla Firefox (IT)": "Mozilla.Firefox.it",
            "Mozilla Thunderbird (IT)": "Mozilla.Thunderbird.it"
        }
        
        # Software aggiuntivo solo per GUI (deselezionati di default)
        self.gui_only_software = {
            "VLC Media Player (IT)": "VideoLAN.VLC",
            "Notepad++ (IT)": "Notepad++.Notepad++",
            "CCleaner": "Piriform.CCleaner",
            "TeamViewer (IT)": "TeamViewer.TeamViewer",
            "Supremo Remote Desktop": "supremo"  # Special case per download diretto
        }
        
        self.winget_available = False
        self.use_gui = False
        self.gui_selections = {}  # Per memorizzare le selezioni aggiuntive dalla GUI
        
    def __del__(self):
        """Distruttore - chiude il logger"""
        if hasattr(self, 'logger'):
            self.logger.close_log()
    
    def parse_arguments(self):
        """Analizza i parametri da riga di comando"""
        start_time = self.logger.log_operation_start("Analisi parametri CLI")
        
        args = [arg.lower() for arg in sys.argv[1:]]
        
        if "/gui" in args or "--gui" in args:
            self.use_gui = True
            self.logger.log_operation_end("Analisi parametri CLI", start_time, True)
            return True  # Segnala di usare la GUI
        
        # Parametri CLI tradizionali - SOLO ORIGINALI
        if "/b" in args:
            self.install_veeam = True
            self.logger.log_debug("Parametro /b rilevato - Veeam Agent da installare")
        if "/f" in args:
            self.install_firefox = True
            self.logger.log_debug("Parametro /f rilevato - Firefox da installare")
        if "/t" in args:
            self.install_thunderbird = True
            self.logger.log_debug("Parametro /t rilevato - Thunderbird da installare")
        if "/w" in args:
            self.run_win_util = True
            self.logger.log_debug("Parametro /w rilevato - WinUtil da eseguire")
            
        self._print_cli_settings()
        self.logger.log_operation_end("Analisi parametri CLI", start_time, True)
        return False  # Segnala di usare la CLI
    
    def _print_cli_settings(self):
        """Stampa le impostazioni CLI"""
        self.logger.info("Parametri di installazione:")
        self.logger.info(f"  Veeam: {self.install_veeam}")
        self.logger.info(f"  Firefox: {self.install_firefox}")
        self.logger.info(f"  Thunderbird: {self.install_thunderbird}")
        self.logger.info(f"  WinUtil: {self.run_win_util}")
        self.logger.info("-" * 50)
    
    def check_winget(self):
        """Verifica se winget è disponibile"""
        start_time = self.logger.log_operation_start("Verifica disponibilità Winget")
        
        try:
            result = subprocess.run(
                ["winget", "--version"], 
                capture_output=True, 
                text=True, 
                check=True
            )
            self.winget_available = True
            version = result.stdout.strip()
            self.logger.info(f"✓ Winget trovato - Versione: {version}")
            self.logger.log_operation_end("Verifica disponibilità Winget", start_time, True)
            return True
        except (subprocess.CalledProcessError, FileNotFoundError) as e:
            self.winget_available = False
            self.logger.log_error("Winget non disponibile", e)
            self.logger.log_operation_end("Verifica disponibilità Winget", start_time, False)
            return False
    
    def run_winget_command(self, command, description=""):
        """Esegue un comando winget con gestione errori"""
        start_time = self.logger.log_operation_start(f"Comando Winget: {description}")
        
        if description:
            self.logger.info(f"Esecuzione: {description}")
        
        try:
            result = subprocess.run(
                command,
                capture_output=True,
                text=True,
                check=True,
                timeout=300  # 5 minuti timeout
            )
            self.logger.info(f"✓ Comando completato: {description}")
            if result.stdout:
                self.logger.debug(f"Output: {result.stdout.strip()}")
            self.logger.log_operation_end(f"Comando Winget: {description}", start_time, True)
            return True
        except subprocess.CalledProcessError as e:
            self.logger.log_error(f"Errore comando: {description}", e)
            if e.stderr:
                self.logger.debug(f"Stderr: {e.stderr.strip()}")
            self.logger.log_operation_end(f"Comando Winget: {description}", start_time, False)
            return False
        except subprocess.TimeoutExpired:
            self.logger.log_error(f"Timeout comando: {description}")
            self.logger.log_operation_end(f"Comando Winget: {description}", start_time, False)
            return False
    
    def download_supremo(self):
        """Scarica Supremo.exe sul desktop"""
        start_time = self.logger.log_operation_start("Download Supremo")
        
        try:
            desktop_path = Path.home() / "Desktop"
            supremo_path = desktop_path / "Supremo.exe"
            
            self.logger.info("Download di Supremo.exe in corso...")
            self.logger.info(f"URL: https://www.nanosystems.it/public/download/Supremo.exe")
            self.logger.info(f"Destinazione: {supremo_path}")
            
            # Download del file
            urllib.request.urlretrieve(
                "https://www.nanosystems.it/public/download/Supremo.exe",
                supremo_path
            )
            
            # Verifica che il file sia stato scaricato
            if supremo_path.exists():
                file_size = supremo_path.stat().st_size
                self.logger.info(f"✓ Supremo scaricato con successo ({file_size} bytes)")
                self.logger.log_operation_end("Download Supremo", start_time, True)
                return True
            else:
                self.logger.error("✗ Download di Supremo fallito - file non creato")
                self.logger.log_operation_end("Download Supremo", start_time, False)
                return False
                
        except Exception as e:
            self.logger.log_error("Errore durante il download di Supremo", e)
            self.logger.log_operation_end("Download Supremo", start_time, False)
            return False
    
    def install_winget(self):
        """Tenta di installare winget"""
        start_time = self.logger.log_operation_start("Installazione Winget")
        self.logger.info("Tentativo di installazione di Winget...")
        
        try:
            # Metodo 1: Usando App Installer
            self.logger.info("Tentativo installazione via PowerShell...")
            subprocess.run([
                "powershell", "-Command",
                "Start-Process powershell -ArgumentList 'Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe' -Verb RunAs"
            ], check=True, capture_output=True, timeout=60)
            
            time.sleep(10)
            
            # Verifica se l'installazione è riuscita
            if self.check_winget():
                self.logger.log_operation_end("Installazione Winget", start_time, True)
                return True
            else:
                # Metodo 2: Apri Microsoft Store
                self.logger.warning("Installazione PowerShell fallita, apertura Store...")
                self.open_winget_store()
                self.logger.log_operation_end("Installazione Winget", start_time, False)
                return False
                
        except (subprocess.CalledProcessError, subprocess.TimeoutExpired) as e:
            self.logger.log_error("Installazione Winget tramite PowerShell fallita", e)
            self.open_winget_store()
            self.logger.log_operation_end("Installazione Winget", start_time, False)
            return False
    
    def open_winget_store(self):
        """Apre il Microsoft Store per installare App Installer"""
        start_time = self.logger.log_operation_start("Apertura Microsoft Store")
        
        try:
            # Ottiene la lingua del sistema
            try:
                with winreg.OpenKey(winreg.HKEY_CURRENT_USER, r"Control Panel\International") as key:
                    locale, _ = winreg.QueryValueEx(key, "LocaleName")
                self.logger.debug(f"Lingua sistema rilevata: {locale}")
            except Exception as e:
                locale = "it-IT"
                self.logger.warning(f"Impossibile rilevare lingua, uso italiano: {locale}")
            
            store_url = f"https://apps.microsoft.com/store/detail/app-installer/9NBLGGH4NNS1?hl={locale}"
            self.logger.info(f"Apertura Microsoft Store: {store_url}")
            
            subprocess.run(["start", store_url], shell=True, check=True, timeout=10)
            self.logger.log_operation_end("Apertura Microsoft Store", start_time, True)
        except Exception as e:
            self.logger.log_error("Errore nell'apertura dello Store", e)
            self.logger.log_operation_end("Apertura Microsoft Store", start_time, False)
    
    def update_all_packages(self):
        """Aggiorna tutti i pacchetti winget"""
        start_time = self.logger.log_operation_start("Aggiornamento pacchetti Winget")
        self.logger.info("Aggiornamento di tutti i pacchetti...")
        success = self.run_winget_command(
            ["winget", "update", "--all", "--include-unknown"], 
            "Aggiornamento pacchetti"
        )
        self.logger.log_operation_end("Aggiornamento pacchetti Winget", start_time, success)
        return success
    
    def install_base_software(self):
        """Installa il pacchetto software di base"""
        start_time = self.logger.log_operation_start("Installazione software di base")
        self.logger.info("Installazione software di base...")
        
        installed_count = 0
        total_count = len(self.base_software)
        
        for name, package_id in self.base_software.items():
            self.logger.log_software_install_attempt(name, package_id)
            success = self.run_winget_command([
                "winget", "install", "-h", "--id", package_id,
                "--accept-package-agreements", "--accept-source-agreements"
            ], f"Installazione {name}")
            
            self.logger.log_software_install_result(name, success)
            if success:
                installed_count += 1
        
        self.logger.info(f"Software base installati: {installed_count}/{total_count}")
        self.logger.log_operation_end("Installazione software di base", start_time, installed_count > 0)
        return installed_count > 0
    
    def install_optional_software(self):
        """Installa il software opzionale in base ai parametri"""
        start_time = self.logger.log_operation_start("Installazione software opzionale")
        
        optional_to_install = {}
        
        # Software opzionali originali
        if self.install_veeam:
            optional_to_install["Veeam Agent"] = self.optional_software["Veeam Agent"]
        if self.install_firefox:
            optional_to_install["Mozilla Firefox (IT)"] = self.optional_software["Mozilla Firefox (IT)"]
        if self.install_thunderbird:
            optional_to_install["Mozilla Thunderbird (IT)"] = self.optional_software["Mozilla Thunderbird (IT)"]
        
        # Software aggiuntivi dalla GUI (se selezionati)
        for name, selected in self.gui_selections.items():
            if selected and name in self.gui_only_software:
                optional_to_install[name] = self.gui_only_software[name]
        
        if not optional_to_install:
            self.logger.info("Nessun software opzionale selezionato")
            self.logger.log_operation_end("Installazione software opzionale", start_time, True)
            return True
        
        self.logger.info(f"Installazione {len(optional_to_install)} software opzionale...")
        installed_count = 0
        
        for name, package_id in optional_to_install.items():
            # Gestione speciale per Supremo (download diretto)
            if name == "Supremo Remote Desktop" and package_id == "supremo":
                success = self.download_supremo()
            else:
                self.logger.log_software_install_attempt(name, package_id)
                success = self.run_winget_command([
                    "winget", "install", "-h", "--id", package_id, "-e",
                    "--accept-package-agreements", "--accept-source-agreements"
                ], f"Installazione {name}")
            
            self.logger.log_software_install_result(name, success)
            if success:
                installed_count += 1
        
        self.logger.info(f"Software opzionale installati: {installed_count}/{len(optional_to_install)}")
        self.logger.log_operation_end("Installazione software opzionale", start_time, installed_count > 0)
        return installed_count > 0
    
    def create_winutil_shortcut(self):
        """Crea un collegamento nel Menu Start per WinUtil"""
        start_time = self.logger.log_operation_start("Creazione collegamento WinUtil")
        self.logger.info("Creazione collegamento WinUtil nel Menu Start...")
        
        try:
            start_menu_path = Path.home() / "AppData" / "Roaming" / "Microsoft" / "Windows" / "Start Menu" / "Programs"
            start_menu_path.mkdir(parents=True, exist_ok=True)
            
            shortcut_script = f"""
$shortcutPath = "{start_menu_path / 'WinUtil - Chris Titus Tech.lnk'}"
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = '-NoExit -Command "& {{ irm https://christitus.com/win | iex }}"'
$shortcut.WorkingDirectory = "{Path.home()}"
$shortcut.WindowStyle = 7
$shortcut.IconLocation = "powershell.exe"
$shortcut.Save()
"""
            
            result = subprocess.run(
                ["powershell", "-Command", shortcut_script],
                capture_output=True,
                text=True,
                check=True,
                timeout=30
            )
            self.logger.info("✓ Collegamento a WinUtil creato nel Menu Start")
            self.logger.log_operation_end("Creazione collegamento WinUtil", start_time, True)
            return True
            
        except Exception as e:
            self.logger.log_error("Errore nella creazione del collegamento", e)
            self.logger.log_operation_end("Creazione collegamento WinUtil", start_time, False)
            return False
    
    def run_winutil(self):
        """Esegue Chris Titus Tech WinUtil"""
        if not self.run_win_util:
            return
        
        start_time = self.logger.log_operation_start("Esecuzione WinUtil")
        self.logger.info("Avvio Chris Titus Tech WinUtil...")
        
        try:
            subprocess.run([
                "powershell", "-Command",
                "Start-Process powershell -ArgumentList 'irm https://christitus.com/win | iex' -Verb RunAs"
            ], check=True, timeout=30)
            self.logger.info("✓ WinUtil avviato con successo")
            self.logger.log_operation_end("Esecuzione WinUtil", start_time, True)
        except Exception as e:
            self.logger.log_error("Errore nell'avvio di WinUtil", e)
            self.logger.log_operation_end("Esecuzione WinUtil", start_time, False)
    
    def install_software(self):
        """Procedura principale di installazione"""
        self.logger.logger.info("=" * 60)
        self.logger.logger.info("MINIKIT ADVANCED - INSTALLAZIONE IN CORSO")
        self.logger.logger.info("=" * 60)
        
        # Registra informazioni sistema
        self.logger.log_system_info()
        
        # Verifica winget
        if not self.check_winget():
            if not self.install_winget():
                self.logger.log_error("Impossibile procedere senza winget")
                return False
        
        # Procedura di installazione con winget
        if self.winget_available:
            self.update_all_packages()
            self.install_base_software()
            self.install_optional_software()
        
        # Se CLI, scarica sempre Supremo
        if not self.use_gui:
            self.logger.info("Modalità CLI - Download automatico di Supremo")
            self.download_supremo()
        
        # Creazione collegamento WinUtil
        self.create_winutil_shortcut()
        
        # Esecuzione WinUtil se richiesto
        self.run_winutil()
        
        self.logger.logger.info("=" * 60)
        self.logger.logger.info("INSTALLAZIONE COMPLETATA")
        self.logger.logger.info("=" * 60)
        return True

    def run_with_gui(self):
        """Avvia l'interfaccia grafica"""
        if not GUI_AVAILABLE:
            self.logger.log_error("tkinter non disponibile. Usa la versione CLI.")
            return False
            
        app = InstallerGUI(self)
        app.run()
        return True


class InstallerGUI:
    def __init__(self, installer):
        self.installer = installer
        self.root = None
        self.check_vars = {}
        
    def run(self):
        """Avvia l'interfaccia grafica"""
        self.root = tk.Tk()
        self.root.title("Software Installer - Minikit Advanced (Italiano)")
        self.root.geometry("600x700")
        self.root.resizable(True, True)
        
        self.setup_ui()
        self.root.mainloop()
    
    def setup_ui(self):
        """Crea l'interfaccia utente"""
        # Frame principale
        main_frame = ttk.Frame(self.root, padding="20")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Titolo
        title_label = ttk.Label(main_frame, text="Minikit Advanced Installer - Italiano", 
                               font=("Arial", 16, "bold"))
        title_label.grid(row=0, column=0, columnspan=2, pady=(0, 10))
        
        # Info logging
        log_info = ttk.Label(main_frame, text=f"Log: {self.installer.logger.log_file}", 
                            foreground="gray", font=("Arial", 8))
        log_info.grid(row=1, column=0, columnspan=2, pady=(0, 10))
        
        # Software di base (sempre installato)
        base_frame = ttk.LabelFrame(main_frame, text="Software di Base (Sempre installato - Italiano)", padding="10")
        base_frame.grid(row=2, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=(0, 15))
        
        row = 0
        for name in self.installer.base_software.keys():
            label = ttk.Label(base_frame, text=f"✓ {name}", foreground="green")
            label.grid(row=row, column=0, sticky=tk.W, pady=2)
            row += 1
        
        # Software opzionale ORIGINALI
        optional_frame = ttk.LabelFrame(main_frame, text="Software Opzionale (Italiano)", padding="10")
        optional_frame.grid(row=3, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=(0, 15))
        
        # Checkbox per software opzionali originali
        self.check_vars["Veeam Agent"] = tk.BooleanVar(value=False)
        self.check_vars["Mozilla Firefox (IT)"] = tk.BooleanVar(value=False)
        self.check_vars["Mozilla Thunderbird (IT)"] = tk.BooleanVar(value=False)
        self.check_vars["WinUtil"] = tk.BooleanVar(value=False)
        
        row = 0
        original_software = ["Veeam Agent", "Mozilla Firefox (IT)", "Mozilla Thunderbird (IT)", "WinUtil"]
        for name in original_software:
            cb = ttk.Checkbutton(optional_frame, text=name, variable=self.check_vars[name])
            cb.grid(row=row, column=0, sticky=tk.W, pady=2)
            row += 1
        
        # Software aggiuntivo solo per GUI (Supremo selezionato di default)
        additional_frame = ttk.LabelFrame(main_frame, text="Software Aggiuntivo Consigliato (Italiano)", padding="10")
        additional_frame.grid(row=4, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=(0, 15))
        
        # Checkbox per software aggiuntivo (solo GUI)
        for name in self.installer.gui_only_software.keys():
            # Supremo selezionato di default, altri deselezionati
            default_value = True if name == "Supremo Remote Desktop" else False
            self.check_vars[name] = tk.BooleanVar(value=default_value)
        
        row = 0
        for name in self.installer.gui_only_software.keys():
            cb = ttk.Checkbutton(additional_frame, text=name, variable=self.check_vars[name])
            cb.grid(row=row, column=0, sticky=tk.W, pady=2)
            row += 1
        
        # Note
        notes_frame = ttk.LabelFrame(main_frame, text="Informazioni", padding="10")
        notes_frame.grid(row=5, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=(0, 20))
        
        notes_text = """• Tutti i software vengono installati in italiano quando disponibile
• Il software di base verrà sempre installato
• Supremo Remote Desktop è selezionato di default (scaricato sul Desktop)
• Gli altri software aggiuntivi sono opzionali e deselezionati di default
• Winget verrà aggiornato automaticamente
• Verrà creato un collegamento a WinUtil nel Menu Start
• Tutte le operazioni vengono registrate nel file di log
• L'installazione richiederà alcuni minuti"""
        
        notes_label = ttk.Label(notes_frame, text=notes_text, justify=tk.LEFT)
        notes_label.grid(row=0, column=0, sticky=tk.W)
        
        # Pulsanti
        button_frame = ttk.Frame(main_frame)
        button_frame.grid(row=6, column=0, columnspan=2, pady=20)
        
        install_btn = ttk.Button(button_frame, text="Avvia Installazione", 
                               command=self.start_installation)
        install_btn.grid(row=0, column=0, padx=(0, 10))
        
        exit_btn = ttk.Button(button_frame, text="Esci", 
                            command=self.root.quit)
        exit_btn.grid(row=0, column=1)
        
        # Configurazione grid weights
        main_frame.columnconfigure(0, weight=1)
        main_frame.rowconfigure(6, weight=1)
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
    
    def start_installation(self):
        """Avvia il processo di installazione con le selezioni dell'utente"""
        # Aggiorna le impostazioni in base alle selezioni GUI
        self.installer.install_veeam = self.check_vars["Veeam Agent"].get()
        self.installer.install_firefox = self.check_vars["Mozilla Firefox (IT)"].get()
        self.installer.install_thunderbird = self.check_vars["Mozilla Thunderbird (IT)"].get()
        self.installer.run_win_util = self.check_vars["WinUtil"].get()
        
        # Memorizza le selezioni dei software aggiuntivi GUI
        self.installer.gui_selections = {}
        for name in self.installer.gui_only_software.keys():
            self.installer.gui_selections[name] = self.check_vars[name].get()
        
        # Log delle selezioni GUI
        self.installer.logger.info("Selezioni dall'interfaccia grafica:")
        self.installer.logger.info(f"  Veeam Agent: {self.installer.install_veeam}")
        self.installer.logger.info(f"  Firefox: {self.installer.install_firefox}")
        self.installer.logger.info(f"  Thunderbird: {self.installer.install_thunderbird}")
        self.installer.logger.info(f"  WinUtil: {self.installer.run_win_util}")
        for name, selected in self.installer.gui_selections.items():
            if selected:
                self.installer.logger.info(f"  {name}: {selected}")
        
        # Conferma
        selected_optional = []
        if self.installer.install_veeam:
            selected_optional.append("Veeam Agent")
        if self.installer.install_firefox:
            selected_optional.append("Mozilla Firefox (IT)")
        if self.installer.install_thunderbird:
            selected_optional.append("Mozilla Thunderbird (IT)")
        if self.installer.run_win_util:
            selected_optional.append("WinUtil")
        
        # Aggiungi software aggiuntivi selezionati
        for name, selected in self.installer.gui_selections.items():
            if selected:
                selected_optional.append(name)
        
        base_list = "\n".join([f"• {name}" for name in self.installer.base_software.keys()])
        optional_list = "\n".join([f"• {name}" for name in selected_optional]) if selected_optional else "Nessuno"
        
        confirm_msg = f"""Conferma installazione:

Software di base (sempre installato in italiano):
{base_list}

Software opzionale selezionato:
{optional_list}

Tutte le operazioni verranno registrate in:
{self.installer.logger.log_file}

Vuoi procedere con l'installazione?"""
        
        if messagebox.askyesno("Conferma Installazione", confirm_msg):
            self.root.destroy()  # Chiude la GUI
            self.installer.install_software()  # Avvia l'installazione


def main():
    """Funzione principale"""
    installer = SoftwareInstaller()
    
    try:
        # Analizza i parametri
        use_gui = installer.parse_arguments()
        
        # Se richiesta la GUI, avviala
        if use_gui:
            if not GUI_AVAILABLE:
                print("ERRORE: tkinter non disponibile. Usa i parametri CLI:")
                print("  /gui - Interfaccia grafica")
                print("  /b   - Installa Veeam Agent")
                print("  /f   - Installa Firefox (IT)") 
                print("  /t   - Installa Thunderbird (IT)")
                print("  /w   - Esegui WinUtil")
                return 1
            return installer.run_with_gui()
        else:
            # Usa la CLI tradizionale - SOLO SOFTWARE ORIGINALI + SUPREMO SEMPRE
            success = installer.install_software()
            
            if success:
                print(f"\nOperazioni completate con successo!")
                print(f"Tutti i software sono stati installati in italiano quando disponibile")
                print(f"Supremo.exe è stato scaricato sul Desktop")
                print(f"Log dettagliato: {installer.logger.log_file}")
            else:
                print(f"\nSi sono verificati alcuni errori durante l'installazione.")
                print(f"Controlla il log: {installer.logger.log_file}")
                
    except KeyboardInterrupt:
        installer.logger.log_error("Installazione interrotta dall'utente")
        print(f"\nInstallazione interrotta. Log: {installer.logger.log_file}")
        return 1
    except Exception as e:
        installer.logger.log_error("Errore critico durante l'installazione", e)
        print(f"\nErrore critico. Controlla il log: {installer.logger.log_file}")
        return 1
    
    input("\nPremere INVIO per uscire...")
    return 0


if __name__ == "__main__":
    sys.exit(main())