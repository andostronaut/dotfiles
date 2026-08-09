<p align="center">
  <img
    src="./assets/banner.png"
    alt="dotfiles"
    style="width:100%;"
  />
</p>

## Configure NVIM Config

Go to the repo directory and use symlink for nvim config

```sh
ln -s $(pwd)/.config/nvim ~/.config/nvim
ln -s $(pwd)/.config/terminalizer ~/.config/terminalizer
```

See [Setup Neovim](#setup-neovim) for the full install, including the
requirements and the post-install steps needed to get a working editor.

## Setup Homebrew

Install homebrew as Package Manager for mac to able to use brew command, check the documentation [here](https://brew.sh/)

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After installing Homebrew, do

```sh
brew bundle --file=Brewfile
```

## Configure Zed

Copy settings from zed [settings](.config/zed/settings.json) to .config/zed/settings.json

Or, using symlink to link directly the folder to your config

```sh
ln -s $(pwd)/.config/zed ~/.config
```

## Configure VSCode

Install VSCode from [here](https://code.visualstudio.com/) or using brew command for mac

```sh
brew install --cask visual-studio-code
```

Copy settings from vscode [settings](.config/vscode/settings.json) to VSCode Settings

Install all extensions that we needed with this command

```sh
cat .config/vscode/extensions.list | xargs -L 1 code --install-extension
```

## Configure Herdr

[Herdr](https://herdr.dev/) is a mouse-first, agent-aware terminal multiplexer.

### Relevant Files

- [.config/herdr/config.toml](.config/herdr/config.toml)

Install Herdr with Homebrew:

```sh
brew install herdr
```

Symlink the config file into place (herdr keeps its logs, sockets, and
`session.json` in `~/.config/herdr`, so symlink just the file, not the folder):

```sh
mkdir -p ~/.config/herdr
ln -sf $(pwd)/.config/herdr/config.toml ~/.config/herdr/config.toml
```

Reload a running server after edits with `prefix+shift+r`, or print the full
commented defaults with `herdr --default-config`.

## Setup Neovim

The config is [NvChad](https://nvchad.com) **v2.5**, built on the official
[NvChad/starter](https://github.com/NvChad/starter) template. NvChad itself is
pulled in as a plugin pinned to branch `v2.5`, so this repo only carries the
config layered on top of it — your customisations live in `lua/plugins/init.lua`
and `lua/configs/`.

### Relevant Files

- [.config/nvim](.config/nvim)

### Setup Requires

- True Color Terminal Like: [Ghostty](https://ghostty.org/) or [iTerm2](https://iterm2.com/)
- [Neovim](https://neovim.io/) (Version 0.11 or Later)
- [Nerd Font](https://www.nerdfonts.com/) - I use Meslo Nerd Font. Avoid fonts ending in `Mono`, their icons render too narrow
- [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter) - required by nvim-treesitter to build parsers
- [Ripgrep](https://github.com/BurntSushi/ripgrep) - For Telescope Fuzzy Finder
- XCode Command Line Tools - provides the C compiler and `make` used to build parsers

Install Deps with Homebrew:

```sh
brew install --cask ghostty

brew install node vim neovim tree-sitter-cli git fd ripgrep lazygit lua luajit
```

> The `tree-sitter` formula is the parsing *library*. The `tree-sitter` binary
> Neovim needs comes from `tree-sitter-cli`.

For XCode Command Line Tools do:

```bash
xcode-select --install
```

Optional deps

```sh
brew install lsd eza tree
```

If you have already installed vim, create a symbolic link to map directly neovim with vim

```sh
ln -s $(which nvim) /opt/homebrew/bin/vim
```

### Install

Symlink the config into place, then launch Neovim:

```sh
ln -s $(pwd)/.config/nvim ~/.config/nvim

nvim
```

On first launch `lazy.nvim` bootstraps itself, installs the plugin set, and
compiles the base46 theme cache. Let it finish before doing anything else.

### Post Install

Run these inside Neovim to get a fully functional editor:

| Command | What it does |
| --- | --- |
| `:Lazy sync` | Install and update plugins. Also how you update later |
| `:TSInstallAll` | Install the treesitter parsers |
| `:Mason` | LSP / formatter / linter installer. Press `i` on a package to install it |

> NvChad v2.5 has **no `:MasonInstallAll`** command. The NvChad docs still
> mention it, but it was removed. Use `:Mason` or `:MasonInstall <package>`.

### Troubleshooting

**`E5113: cannot open .../base46/defaults` on startup.** The theme cache was
never compiled, which happens when state from another Neovim distro is still
sitting in the shared data directories — an existing `lazy.nvim` there makes the
bootstrap skip itself. Clear the state and relaunch:

```sh
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim

nvim
```

**Icons show as boxes or question marks.** The terminal font is not a Nerd Font,
or it is a `Mono` variant. Switch to a full Nerd Font build.

**A server is rejected from `ensure_installed`.** LSP names in the mason
config are lspconfig names, and upstream renames them from time to time —
`tsserver` became `ts_ls`, `volar` became `vue_ls`. Check the current name with
`:Mason`. Some servers have no mason package at all (`dartls` ships inside the
Dart SDK, `rustfmt` comes from rustup).

## Setup Terminalizer

Install Terminalizer from NPM

```sh
npm install -g terminalizer
```

## Uninstall nvim

Removing all four paths gives you a clean slate. Leaving state behind in
`~/.local/share/nvim` is what causes the bootstrap to silently skip itself:

```sh
# Linux / Macos (unix)
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

# Windows
rd -r ~\AppData\Local\nvim
rd -r ~\AppData\Local\nvim-data
```

## License

[MIT](LICENSE)
