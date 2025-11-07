# Mini-Kit Advanced

![Versione](https://img.shields.io/badge/Versione-25.11-blue.svg)
![Windows](https://img.shields.io/badge/Windows-10%2F11%2FServer-green.svg)
![Licenza](https://img.shields.io/badge/Licenza-MIT-orange.svg)

## 📋 Descrizione

**Mini-Kit Advanced** è uno script batch di automazione per l'installazione software su sistemi Windows. Progettato per tecnici IT e sistemisti, permette di automatizzare l'installazione di software essenziali e strumenti di utilità con un singolo comando.

**Autore**: Daniele Lolli (UncleDan)

## ✨ Caratteristiche

- 🚀 **Installazione automatica** di software tramite Windows Package Manager (winget)
- ⚡ **Doppia modalità**: Base (senza parametri) e Opzionale (con parametri)
- 📊 **Logging avanzato** con timestamp per tracciare tutte le operazioni
- 🔧 **Integrazione WinUtil** di Chris Titus Tech
- 🎯 **Supporto multilingua** (versioni italiane dei software)
- 🛡️ **Gestione errori** completa con report dettagliati

## 🛠️ Software Supportati

### 🏠 Software Base (installati senza parametri)
- **7-Zip** - Compressione file
- **Adobe Reader IT** - Visualizzatore PDF
- **Google Chrome IT** - Browser web
- **Speccy** - Analisi hardware
- **LibreOffice IT** - Suite office
- **Supremo Remote Desktop** - Desktop remoto (scaricato sul Desktop)

### ⚙️ Software Opzionali (installati con parametri)
- **PowerShell** (`-p` o `--powershell`)
- **Veeam Agent** (`-b` o `--backup`) - Soluzione backup
- **Firefox IT** (`-f` o `--firefox`) - Browser web
- **Thunderbird IT** (`-r` o `--thunderbird`) - Client email
- **Notepad++ IT** (`-n` o `--notepad`) - Editor di testo avanzato
- **TeamViewer IT** (`-t` o `--teamviewer`) - Desktop remoto
- **Visual Studio Code** (`-v` o `--vscode`) - Editor di codice

## 🚀 Utilizzo

### Installazione tutto software base
```cmd
minikit-advanced.cmd
```

### Installazione software opzionali specifici
```cmd
REM Solo PowerShell + Veeam + Firefox
minikit-advanced.cmd -p -b -f

REM Solo Notepad++ + TeamViewer + VS Code
minikit-advanced.cmd -n -t -v

REM Solo Firefox + Thunderbird
minikit-advanced.cmd -f -r
Altre opzioni
cmd
REM Esegui Chris Titus Tech WinUtil
minikit-advanced.cmd -w

REM Mostra guida
minikit-advanced.cmd -h
```

## 📋 Tabella Comandi Completa

| Comando breve | Comando lungo | Descrizione |
|---------------|-----------------|-----------------------------------------|
| `-p`          | `--powershell`  | Installa PowerShell                     |
| `-b`          | `--backup`      | Installa Veeam Agent per backup         |
| `-f`          | `--firefox`     | Installa Mozilla Firefox (italiano)     |
| `-r`          | `--thunderbird` | Installa Mozilla Thunderbird (italiano) |
| `-n`          | `--notepad`     | Installa Notepad++ (italiano)           |
| `-t`          | `--teamviewer`  | Installa TeamViewer (italiano)          |
| `-v`          | `--vscode`      | Installa Visual Studio Code             |
| `-w`          | `--winutil`     | Esegue Chris Titus Tech WinUtil         |
| `-h`          | `--help`        | Mostra questa guida                     |

## 🔧 Requisiti di Sistema

* **Windows** 10, 11 o Windows Server
* **Windows Package Manager (winget)** versione 1.0 o superiore
* **Permessi amministrativi** per l'installazione software
* **Connessione Internet** per il download dei pacchetti

## ⚡ Integrazione WinUtil

Esecuzione diretta di *Chris Titus Tech WinUtil*

## 🤝 Contribuzioni

Le contribuzioni sono benvenute! Per contribuire:

1. Fork del progetto
2. Crea un branch per la tua feature (git checkout -b feature/AmazingFeature)
3. Commit delle modifiche (git commit -m 'Add some AmazingFeature')
4. Push sul branch (git push origin feature/AmazingFeature)
5. Apri una Pull Request

## 📄 Licenza
Distribuito sotto licenza MIT. Vedi LICENSE per maggiori informazioni.

## 👨‍💻 Autore
Daniele Lolli (UncleDan)
Email: uncledan@uncledan.it
Sito Web: https://uncledan.it

## 🙏 Ringraziamenti
* **Chris Titus** per WinUtil
* **Microsoft** per Windows Package Manager
* **Tutti gli sviluppatori dei software** inclusi nel kit

---

⚠️ **Disclaimer**: Usare a proprio rischio. L'autore non è responsabile per eventuali danni causati dall'uso di questo software.