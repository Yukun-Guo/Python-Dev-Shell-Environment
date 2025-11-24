# 🐍 Python Dev Shell Environment

A cross-platform (**Ubuntu / MacOS**) efficient development environment setup script designed specifically for Python developers.  
Includes common tools, command aliases, syntax highlighting, intelligent completion, `fzf` search, Starship prompt styling, and more.

---

## ✨ Feature Overview

✅ **Cross-platform support:**

- 🐧 Ubuntu / Debian  
- 🍎 macOS (Homebrew)  

✅ **Terminal enhancements:**

- Fish (Linux/macOS)  
- Starship minimalist prompt  
- `fzf` for fuzzy search and command history lookup  
- `bat` (syntax-highlighted `cat`)  
- `exa` (iconic file listing)  
- `ripgrep` (ultra-fast text search)  
- Automatic Python environment and `uv` integration  

✅ **Python integration:**

- Uses [`uv`](https://github.com/astral-sh/uv) for environment and package management (faster than pip/venv)  
- Common aliases: `py`, `act`, `mkvenv`, `rmpycache`  
- No auto-activation of `.venv`; full manual control (you can run `act` manually)

✅ **Convenient command aliases:**
You can view all shortcuts with:

``` bash
help
```

Output:

``` bash
==============================
 ⚡ Python Dev Shell Help
==============================
ll, la, py, act, deactivate, mkvenv, rmpycache
gs, gc, gp, ga, gl
cls, .., ..., update, extract, zipit, ports, killport, serve, findpy
fhist, help
==============================
```

---

## 🚀 Installation Steps

### 🐧 Ubuntu / Debian

``` bash
curl -fsSL https://raw.githubusercontent.com/Yukun-Guo/Python-Dev-Shell-Environment/refs/heads/main/install_dev_shell.sh | bash
```

Or manually execute:

``` bash
chmod +x install_dev_shell.sh
./install_dev_shell.sh
```

> 📦 Depend encies will be automatically installed: fish, fzf, bat, exa, ripgrep, python3, pip, uv, starship

After installation:

``` bash
chsh -s /usr/bin/fish
fish
```

---

### 🍎 macOS

``` bash
curl -fsSL https://raw.githubusercontent.com/Yukun-Guo/Python-Dev-Shell-Environment/refs/heads/main/install_dev_shell.sh | bash
```

The system will automatically install:

- Homebrew (if not already installed)
- fish, fzf, bat, exa, ripgrep, starship  
- Python, uv, ipython, ruff  

After installation, restart the terminal or run:

``` bash
fish
```

---

## 🧠 Common Commands

| Command | Description |
|----------|--------------|
| `help` | Display all available commands and descriptions |
| `ll` | Iconic long listing (`exa -alh --icons`) |
| `la` | Show all files (including hidden ones) |
| `cat` | Syntax-highlighted file content viewer (`bat`) |
| `py` | Run Python scripts via `uv` |
| `act` | Activate `.venv` in the current directory |
| `mkvenv` | Create a virtual environment (`uv venv`) |
| `rmpycache` | Remove all `__pycache__` folders |
| `gs` / `ga` / `gc` / `gp` / `gl` | Git shortcuts |
| `cls` | Clear the screen |
| `..`, `...` | Quick directory navigation |
| `update` | One-click system or Homebrew update |
| `extract`, `zipit` | Quick extract/compress files |
| `ports` | View listening ports |
| `killport` | Kill the process occupying a port |
| `serve` | Launch local HTTP server (`python -m http.server`) |
| `findpy` | Find all `.py` files in the project |
| `fhist` | Search and execute command history via `fzf` |

---

## ⚙️ Configuration File Locations

| System | Path |
|---------|------|
| Ubuntu / macOS | `~/.config/fish/config.fish` |

---

## 🧩 Extension Tips

You can add your own aliases or functions in `config.fish` or PowerShell profile, for example:

``` bash
# Add virtual environment indicator
function show_venv
    if test -n "$VIRTUAL_ENV"
        echo "🐍 Venv: (basename $VIRTUAL_ENV)"
    end
end
function fish_prompt
    show_venv
    starship prompt
end
```

---

## 🩺 Troubleshooting

| Problem | Cause | Solution |
|----------|--------|-----------|
| `exa: command not found` | exa not installed | Run `brew install exa` or `sudo apt install exa` |
| `uv: command not found` | pip not installed properly | Run `pip install uv --upgrade` |
| PowerShell profile not effective | Permission issue | Run `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force` |
| Garbled icons | Nerd Font not installed | Install [MesloLGS NF](https://www.nerdfonts.com/font-downloads) and enable it in terminal |

---

## 💡 Tips

- The `help` command is always your best friend.  
- Both Fish and PowerShell support tab auto-completion.  
- For the best experience, use [Starship](https://starship.rs/) + [Nerd Font](https://www.nerdfonts.com/).

---

## 🧰 Uninstall

``` bash
rm -rf ~/.config/fish
brew uninstall fish fzf bat exa ripgrep starship
pip uninstall uv ipython ruff
```

Windows:
``` powershell
scoop uninstall fish fzf bat exa starship
Remove-Item $PROFILE
```

---

## 🧑‍💻 Author’s Note

> Designed for serious Python developers, data scientists, and researchers.  
Feel free to fork and customize it to suit your workflow!
