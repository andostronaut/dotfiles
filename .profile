# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/profile.pre.bash" ]] && builtin source "$HOME/.fig/shell/profile.pre.bash"
# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/bashrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/bashrc.pre.zsh"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/bashrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/bashrc.pre.zsh"

[[ -s "/Users/andoramanamihanta/.gvm/scripts/gvm" ]] && source "/Users/andoramanamihanta/.gvm/scripts/gvm"

. "$HOME/.cargo/env"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/profile.post.bash" ]] && builtin source "$HOME/.fig/shell/profile.post.bash"
