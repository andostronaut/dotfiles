#!/bin/bash

dotfiles=(
  .bashrc
  .zshrc
  .vimrc
  .gitconfig
)

dotfiles_dir="$HOME/.dotfiles"

backup_existing_dotfiles() {
  backup_dir="$HOME/.dotfiles_backup/$(date +"%Y%m%d%H%M%S")"
  
  mkdir -p "$backup_dir"

  for dotfile in "${dotfiles[@]}"; do
    if [ -f "$HOME/$dotfile" ]; then
      mv "$HOME/$dotfile" "$backup_dir"
      echo "Backed up: $dotfile"
    fi
  done
}

create_symlinks() {
  for dotfile in "${dotfiles[@]}"; do
    ln -s "$dotfiles_dir/$dotfile" "$HOME/$dotfile"
    echo "Linked: $dotfile"
  done
}

main() {
  echo "Installing dotfiles..."

  backup_existing_dotfiles
  create_symlinks

  echo "Dotfiles installation completed!"
}

main
