#!/bin/bash

set -uo pipefail

# Symlink tracked config into $HOME. Everything is linked, never copied, so an
# edit to the repo takes effect immediately and an app writing its config back
# shows up here as a dirty file.
#
# Two levels of linking, because some apps keep live state next to their
# tracked config:
#
#   whole directory  the repo owns every file under it, one symlink is enough
#   single file      the app also stores plugins/locks/logs there, so linking
#                    the directory would hide them

# resolve the repo root from this script's own location, so the repo works
# wherever it is cloned rather than only at ~/.dotfiles
dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# $HOME/<name> -> repo/<name>. .config is deliberately absent, it is linked
# per entry below so unrelated tools in ~/.config are left alone.
home_entries=(
  .bashrc
  .editorconfig
  .gitconfig
  .profile
  .tmux.conf
  .zshenv
  .zshrc
  # ~/.claude also holds CLAUDE.md, projects/ and daemon state, so only the
  # tracked file is linked
  .claude/settings.local.json
)

# entries under .config, relative to it. Directories the repo owns outright.
config_dirs=(
  cursor
  ghostty
  nvim
  terminalizer
  vscode
  zed
)

# herdr keeps .plugins.lock, logs and installed plugins in the same directory,
# and every plugin's own config dir lives under herdr/plugins/config
config_files=(
  herdr/config.toml
  # herdr-lazy's declarative plugin set and its lockfile, the record of which
  # plugins to reinstall and at which commits
  herdr/plugins/config/herdr-lazy/plugins.list
  herdr/plugins/config/herdr-lazy/plugins.lock
)

# .gitignore and .versions belong to the repo itself and are deliberately not
# linked into $HOME.

dry_run=false
backup_dir="$HOME/.dotfiles_backup/$(date +"%Y%m%d%H%M%S")"
linked=0
skipped=0
backed_up=0

usage() {
  echo "Usage: $(basename "$0") [--dry-run]"
  echo
  echo "  --dry-run  show what would change without touching anything"
}

parse_args() {
  for arg in "$@"; do
    case "$arg" in
      --dry-run) dry_run=true ;;
      -h | --help)
        usage
        exit 0
        ;;
      *)
        echo "Unknown option: $arg" >&2
        usage >&2
        exit 1
        ;;
    esac
  done
}

# move whatever currently occupies $1 into the backup directory, keeping its
# path so two files with the same basename cannot collide
back_up() {
  local dest="$1"
  local rel="${dest#"$HOME"/}"
  local target="$backup_dir/$rel"

  if $dry_run; then
    echo "  would back up: $rel"
    backed_up=$((backed_up + 1))
    return
  fi

  mkdir -p "$(dirname "$target")"
  mv "$dest" "$target"
  echo "  backed up: $rel"
  backed_up=$((backed_up + 1))
}

# link $1 (inside the repo) to $2 (inside $HOME)
link_one() {
  local src="$1"
  local dest="$2"
  local rel="${dest#"$HOME"/}"

  if [ ! -e "$src" ]; then
    echo "  missing in repo, skipped: ${src#"$dotfiles_dir"/}" >&2
    skipped=$((skipped + 1))
    return
  fi

  # already pointing where we want it
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    skipped=$((skipped + 1))
    return
  fi

  # -e is false for a broken symlink, so test -L as well
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    back_up "$dest"
  fi

  if $dry_run; then
    echo "  would link: $rel"
    linked=$((linked + 1))
    return
  fi

  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "  linked: $rel"
  linked=$((linked + 1))
}

link_home_entries() {
  local name
  for name in "${home_entries[@]}"; do
    link_one "$dotfiles_dir/$name" "$HOME/$name"
  done
}

link_config_entries() {
  local name
  for name in "${config_dirs[@]}" "${config_files[@]}"; do
    link_one "$dotfiles_dir/.config/$name" "$HOME/.config/$name"
  done
}

main() {
  parse_args "$@"

  echo "Installing dotfiles from $dotfiles_dir"
  $dry_run && echo "(dry run, nothing will be changed)"
  echo

  # .config is linked per entry rather than wholesale, so unrelated tools in
  # ~/.config (gh, mise, starship) are left alone
  link_config_entries
  link_home_entries

  echo
  echo "linked: $linked   already correct: $skipped   backed up: $backed_up"
  if [ "$backed_up" -gt 0 ] && ! $dry_run; then
    echo "backups in: $backup_dir"
  fi
}

main "$@"
