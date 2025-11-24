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
        sudo apt install -y git fzf bat exa ripgrep unzip python3 python3-pip curl

        # Check Fish version, upgrade if <3.4
        FISH_VER=$(fish --version | awk '{print $3}')
        VER_CHECK=$(printf '%s\n%s' "3.4" "$FISH_VER" | sort -V | head -n1)
        if [[ "$VER_CHECK" == "$FISH_VER" ]]; then
            echo "🔧 Upgrading Fish shell to latest 3.4+..."
            sudo apt-add-repository ppa:fish-shell/release-3 -y
            sudo apt update
            sudo apt install -y fish
        fi

        # Install Starship using POSIX sh
        if ! command -v starship &> /dev/null; then
            echo "🔧 Installing Starship..."
            sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes
        fi

        EXA_CMD="exa"
    else
        # macOS
        if ! command -v brew >/dev/null 2>&1; then
            echo "🍺 Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew tap homebrew/core --force
        if brew search exa | grep -qx "exa"; then
            brew install fish git fzf bat exa ripgrep unzip python starship
            EXA_CMD="exa"
        else
            brew install fish git fzf bat eva ripgrep unzip python starship
            EXA_CMD="eva"
        fi
    fi

    # Upgrade pip & install Python packages
    pip3 install --upgrade pip
    pip3 install uv ipython ruff

    # Fish configuration
    mkdir -p ~/.config/fish/functions
    cat > ~/.config/fish/config.fish <<EOF
# Add ~/.local/bin to PATH
set -U fish_user_paths \$HOME/.local/bin \$fish_user_paths

# Remove old env.fish references (if any)
# source /home/yukun/snap/code/204/.local/share/../bin/env.fish

# Initialize Starship prompt only if installed
if type -q starship
    starship init fish | source
end

# Aliases
alias ll="${EXA_CMD} -alh --icons"
alias la="${EXA_CMD} -a --icons"
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
alias update="sudo apt update -y && sudo apt upgrade -y"
alias extract="tar -xvf"
alias zipit="zip -r"
alias ports="lsof -i -P -n | grep LISTEN"
alias killport="sudo lsof -iTCP -sTCP:LISTEN -t | xargs kill -9"
alias serve="python3 -m http.server"
alias findpy="find . -type f -name '*.py'"

function fhist
    history | fzf | read -l cmd; and eval \$cmd
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
EOF

    echo "✅ $PLATFORM setup complete!"
fi

# --------------------------
# Windows (unchanged)
# --------------------------
if [[ "$OS_TYPE" == MINGW* || "$OS_TYPE" == MSYS* || "$OS_TYPE" == CYGWIN* ]]; then
    echo "Platform detected: windows"
    echo "⚠️ Running Windows PowerShell installation..."
    # ... existing Windows code ...
fi

echo "💡 Cross-platform installation finished! Use 'help' to see all commands."
