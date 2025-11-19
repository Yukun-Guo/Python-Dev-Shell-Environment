#!/usr/bin/env bash
set -e

echo "🔧 Installing Python Dev Shell Environment (Cross-Platform)..."

OS_TYPE="$(uname -s)"
echo "Detected OS: $OS_TYPE"

# --------------------------
# Ubuntu / macOS
# --------------------------
if [[ "$OS_TYPE" == "Linux" || "$OS_TYPE" == "Darwin" ]]; then
    PLATFORM="$([[ "$OS_TYPE" == "Linux" ]] && echo "ubuntu" || echo "macos")"
    echo "Platform detected: $PLATFORM"

    if [[ "$PLATFORM" == "ubuntu" ]]; then
        sudo apt update -y
        sudo apt install -y fish git fzf bat exa ripgrep unzip python3 python3-pip curl
    else
        # macOS
        if ! command -v brew >/dev/null 2>&1; then
            echo "🍺 Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew tap homebrew/core --force
        brew install fish git fzf bat eva ripgrep unzip python starship
    fi

    # Install Python packages
    pip3 install --upgrade pip
    pip3 install uv ipython ruff

    # Fish configuration
    mkdir -p ~/.config/fish/functions
    cat > ~/.config/fish/config.fish <<'EOF'
starship init fish | source

alias ll="exa -alh --icons"
alias la="exa -a --icons"
alias cat="bat"
alias py="uv run python"
alias act="source .venv/bin/activate.fish"
alias deactivate="deactivate || echo 'No venv active'"
alias mkvenv="uv venv"
alias rmpycache="find . -type d -name '__pycache__' -exec rm -rf {} +"

alias gs="git status"
alias gc="git commit -m"
alias gp="git push"
alias ga="git add ."
alias gl="git log --oneline --graph"

alias cls="clear"
alias ..="cd .."
alias ...="cd ../.."
alias update="brew update && brew upgrade || sudo apt update -y && sudo apt upgrade -y"
alias extract="tar -xvf"
alias zipit="zip -r"
alias ports="lsof -i -P -n | grep LISTEN"
alias killport="sudo lsof -iTCP -sTCP:LISTEN -t | xargs kill -9"
alias serve="python3 -m http.server"
alias findpy="find . -type f -name '*.py'"

function fhist
    history | fzf | read -l cmd; and eval $cmd
end

function devhelp
    echo "=============================="
    echo " ⚡ Python Dev Shell Help"
    echo "=============================="
    echo "ll, la, py, act, deactivate, mkvenv, rmpycache"
    echo "gs, gc, gp, ga, gl"
    echo "cls, .., ..., update, extract, zipit, ports, killport, serve, findpy"
    echo "fhist, help"
    echo "=============================="
end
alias help="devhelp"

# fzf completion (only source Homebrew-installed fzf files when brew is available)
# If fzf was installed via apt / system package, those completions may be elsewhere.
if type -q brew
    set -l BREW_PREFIX (brew --prefix)
    if test -f "$BREW_PREFIX/opt/fzf/shell/completion.fish"
        source "$BREW_PREFIX/opt/fzf/shell/completion.fish"
    end
    if test -f "$BREW_PREFIX/opt/fzf/shell/key-bindings.fish"
        source "$BREW_PREFIX/opt/fzf/shell/key-bindings.fish"
    end
end
EOF

    echo "✅ $PLATFORM setup complete!"
fi

# --------------------------
# Windows
# --------------------------
if [[ "$OS_TYPE" == MINGW* || "$OS_TYPE" == MSYS* || "$OS_TYPE" == CYGWIN* ]]; then
    echo "Platform detected: windows"
    echo "⚠️ Running Windows PowerShell installation..."

    powershell -NoProfile -Command "& {
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        if (-Not (Get-Command scoop -ErrorAction SilentlyContinue)) {
            Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
        }

        scoop install pwsh git python fzf bat exa unzip starship

        python -m pip install --upgrade pip
        pip install uv ipython ruff

        # PowerShell profile config
        if (-Not (Test-Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE -Force }
        Add-Content $PROFILE @'
Import-Module PSReadLine
Set-PSReadLineOption -EditMode Windows
Invoke-Expression (&starship init powershell)

Set-Alias ll exa
Set-Alias la "exa -a"
Set-Alias cat bat
Set-Alias py "uv run python"
Set-Alias act "uv activate"
Set-Alias deactivate "deactivate"
Set-Alias mkvenv "uv venv"
Set-Alias rmpycache "Get-ChildItem -Recurse -Force -Directory -Include '__pycache__' | Remove-Item -Recurse -Force"

Set-Alias gs git status
Set-Alias gc "git commit -m"
Set-Alias gp git push
Set-Alias ga git add .
Set-Alias gl "git log --oneline --graph"

Set-Alias cls Clear-Host
Set-Alias .. Set-Location ..
Set-Alias ... Set-Location ../..
Set-Alias update "scoop update *"
Set-Alias extract tar -xvf
Set-Alias zipit Compress-Archive
Set-Alias ports "netstat -ano | findstr LISTENING"
Set-Alias killport "Stop-Process -Id"
Set-Alias serve "python -m http.server"
Set-Alias findpy "Get-ChildItem -Recurse -Include '*.py'"

# fzf key bindings and completion
if (Test-Path (scoop prefix fzf) + '\\shell\\key-bindings.ps1') { . (scoop prefix fzf) + '\\shell\\key-bindings.ps1' }
if (Test-Path (scoop prefix fzf) + '\\shell\\completion.ps1') { . (scoop prefix fzf) + '\\shell\\completion.ps1' }

function devhelp {
    Write-Host '=============================='
    Write-Host ' ⚡ Python Dev Shell Help'
    Write-Host '=============================='
    Write-Host 'll, la, py, act, deactivate, mkvenv, rmpycache'
    Write-Host 'gs, gc, gp, ga, gl'
    Write-Host 'cls, .., ..., update, extract, zipit, ports, killport, serve, findpy'
    Write-Host 'Ctrl-R (fzf), help'
    Write-Host '=============================='
}
Set-Alias help devhelp
'@
        Write-Host '✅ Windows setup complete! Restart PowerShell 7 or Windows Terminal.'
    }"
fi

echo "💡 Cross-platform installation finished! Use 'help' to see all commands."
