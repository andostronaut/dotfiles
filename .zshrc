# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Prompt is handled by starship, so no oh-my-zsh theme.
ZSH_THEME=""

plugins=(
    git
    gh
    brew
    zsh-autosuggestions
    fast-syntax-highlighting
    zsh-autocomplete
    bun
    deno
    docker
    docker-compose
    golang
    mise
    rust
    ssh
    tmux
)

source $ZSH/oh-my-zsh.sh

# Terminal/tab title: just the current folder, not user@host:path
ZSH_THEME_TERM_TITLE_IDLE="%1~"
ZSH_THEME_TERM_TAB_TITLE_IDLE="%1~"

# Prompt (mise is activated by its oh-my-zsh plugin)
eval "$(starship init zsh)"

# Deno
. "$HOME/.deno/env"

# Bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Java (Android SDK)
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# wt, when installed
if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
