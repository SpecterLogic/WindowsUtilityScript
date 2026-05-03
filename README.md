# 🛠️ WindowsUtilityScript – Windows System Repair & Maintenance Toolkit (Batch)

[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**WindowsUtilityScript** is a single batch file that brings together essential Windows troubleshooting tools in an interactive terminal menu.  
No installation required – just run `WindowsUtilityScript.bat` as Administrator and pick a task.

---

## 🚀 Features

- **File & Folder Lock Removal** – Take ownership, grant full control, force delete locked files/folders.
- **Windows Update Repair** – Stop services, reset SoftwareDistribution and Catroot2, restart services.
- **Network Reset & Repair** – Full TCP/IP reset, Winsock reset, DNS flush, and Wi‑Fi reconnection.
- **System Cleanup** – Wipe User/System temp, Prefetch, browser cache (Chrome, Edge), empty Recycle Bin.
- **Heavy Process Killer** – Kill Chrome, Edge, VS Code instantly; or use a PowerShell‑powered RAM hog list.
- **One‑Click Full Repair** – Run all major fixes in sequence.
- **Professional terminal UI** – Large ASCII art logo, clear menus, and safety confirmations.

---

## 📦 Requirements

- Windows 10 / 11 (any edition)
- **Run as Administrator** (the script auto‑elevates if permitted)

---

## 🔧 How to Use

1. **Download** `WindowsUtilityScript.bat`.
2. **Double‑click** the file – it will ask for Administrator permission.
3. Choose a task from the numbered menu.
4. Follow the on‑screen instructions.

> ⚠️ **Important:** Some actions (especially file deletion and service resets) are irreversible.  
> Read the prompts carefully.

---

## 📖 Menu Overview

| #   | Option                                | Description                                            |
| --- | ------------------------------------- | ------------------------------------------------------ |
| 1   | File Permission & Locked File Removal | Take ownership + grant full control, force deletes.    |
| 2   | Windows Update Repair                 | Stop services, rename cache folders, restart services. |
| 3   | Network Reset & Repair                | Full IP/Winsock/DNS reset, Wi‑Fi reconnect.            |
| 4   | System Cleanup & Disk Space Free‑up   | Temp files, browser cache, Prefetch, Recycle Bin.      |
| 5   | Kill Heavy Processes & Free RAM       | Kill Chrome/Edge/VS Code, or interactive RAM hog list. |
| 6   | Quick Full Repair (One‑click)         | Run all repairs + cleanup + kill heavy apps.           |
| 7   | Exit                                  |                                                        |

---

## 🛡️ Disclaimer

This script performs system‑level operations. It is designed to be safe, but you use it **at your own risk**.  
Always back up important data before running extensive cleanup or repair tasks.  
The author is not responsible for any data loss or system instability.

---

## 📜 License

MIT – see the [LICENSE](LICENSE) file for details.

---

## 🤝 Contributing

Pull requests, issues, and suggestions are welcome!  
Please open an issue first to discuss major changes.

---

**Made with ❤️ by the SpecterLogic**
