if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Export brew
export PATH=/opt/homebrew/bin:$PATH

# Vim alias
alias vim="nvim"

# Git Aliases
alias initieo="git init"
alias commiteo="git commit"
alias pusheo="git push"
alias mergeo="git merge"
alias rebaseo="git rebase"
alias stasheo="git stash"
alias logeo="git log"
alias checkouteo="git checkout"

# Dir Aliases
alias repos="cd ~/Documents/repos"
alias labs="cd ~/Documents/labs"

# Gnubin
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)

source $ZSH/oh-my-zsh.sh

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Source Kubectl Completion
source <(kubectl completion zsh)

# Curl
export PATH="/opt/homebrew/opt/curl/bin:$PATH"

# ASDF
. "$HOME/.asdf/asdf.sh"
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

# ASDF PHP
export PATH="/opt/homebrew/opt/bison/bin:$PATH"
export PATH="/opt/homebrew/opt/libiconv/bin:$PATH"
export PATH="/opt/homebrew/opt/jpeg/bin:$PATH"
export PATH="/opt/homebrew/opt/libxml2/bin:$PATH"

# ASDF GO
# set goroot in shell init
. ~/.asdf/plugins/golang/set-env.zsh
export GOPATH=$(asdf where golang)/packages
export GOROOT=$(asdf where golang)/go
export PATH="${PATH}:$(go env GOPATH)/bin"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/andoramanamihanta/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/andoramanamihanta/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/andoramanamihanta/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/andoramanamihanta/google-cloud-sdk/completion.zsh.inc'; fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Source Cargo Env
source "$HOME/.cargo/env"
