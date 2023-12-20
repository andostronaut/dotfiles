<p align="center">
  <img
    src="./assets/banner.png"
    alt="dotfiles"
    style="width:100%;"
  />
</p>

## Setup TMUX

Install TMUX with Homebrew:

```sh
brew install tmux
```

Install Tpm (TMUX Package Manager):

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Install all plugins in TMUX with command: `Ctrl-a + Shift-i`

## Setup Neovim

Install Deps with Homebrew:

```bash
brew install vim neovim tree-sitter lsd eza git fd ripgrep lazygit lua luajit tree
```

If you have already installed vim, create a symbolic link to map directly neovim with vim

```sh
ln -s $(which nvim) /opt/homebrew/bin/vim
```

## License

[MIT licensed](LICENSE).
