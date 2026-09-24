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

## Herdr Plugins

Seven plugins, declared in
[plugins.list](.config/herdr/plugins/config/herdr-lazy/plugins.list) and pinned
to commits in
[plugins.lock](.config/herdr/plugins/config/herdr-lazy/plugins.lock). Both files
are symlinked into `~/.config/herdr`, so `herdr-lazy sync` rebuilds the set on a
new machine.

| Plugin | What it does |
| --- | --- |
| clauth | Multi-account Claude switcher, usage windows, auto-switch chain |
| hhdebb.herdr-radar | Agents card: project grouping, vendor logos, state by colour |
| herdr.auto-title | Names tabs and panes after the work in them |
| itisbryan/herdr-gh-checks | Current PR's CI, checks and merge state, in a pane |
| jmarbutt.spaces-pr-status | GitHub PR state beside each branch in the spaces card |
| herdr-lazy | Declarative plugin management, the two files above |
| persiyanov.reviewr | Comment on the agent's diff and send it back |

The agents card is herdr's own; the spaces card carries PR state. A run of plugins that each wanted a piece
of it — usage meters, quota bars, PR state, CPU/RAM, a full agents-list
replacement — were tried and removed; between them they fought over the same
three tables, and the result was busier and less readable than the default.
Only `$clauth` is added back, because it answers a question the sidebar cannot:
which account a pane is spending.

### Keys

Prefix is `ctrl+space`. Unlisted keys keep herdr's defaults.

| Key | Does |
| --- | --- |
| `prefix+a` | clauth: accounts, usage, auto-switch chain |
| `prefix+shift+a` | Agents: active <-> recent (radar view flip) |
| `prefix+comma` | herdr-radar settings |
| `prefix+d` | reviewr: toggle review pane (d for diff) |
| `prefix+m` | gh-checks: PR CI, checks and merge (m for merge) |
| `prefix+shift+l` | herdr-lazy: manage plugins |

### Using clauth

`prefix+a` opens the dashboard over whatever is running. Switch accounts with a
keystroke inside it, `q` to quit. There is no separate account picker by design,
and herdr allows one popup per session.

That switches the *global* credentials. To pin one pane to one account:

```sh
clauth start <profile>                   # claude in that profile's own CLAUDE_CONFIG_DIR
clauth start <profile> -- --model haiku  # flags after -- go to claude
```

`clauth login <name>` adds an account, `clauth list` shows them with usage.
The `$clauth` sidebar token is deliberately not in any row — the account is
in the dashboard, not on every line. `clauth herdr install` writes it back
into `rows_by_agent`, so re-remove it if that is ever re-run.

### auto-title needs a newer Go than mise pins

`go.mod` asks for `go 1.24`; `~/.config/mise/config.toml` pins `go = "1.21"`
and there are no prebuilt binaries, so the install builds from source. It works
anyway because `GOTOOLCHAIN` is `auto`, so Go 1.21 fetches a 1.24 toolchain on
demand — verified by building a `go 1.24` module, which produced `go1.24.0`.
If `GOTOOLCHAIN` is ever set to `local`, this install breaks.

Its settings are env vars in `~/.config/herdr-auto-title/config.env`, not here:
`HERDR_AUTO_TITLE_MAX_LENGTH` (50), `_BRANCH_MAX` (12, `0` hides branches),
`_POSITION` (tab index in front), `_POLL_MS` (500). It reads the file once at
startup, so `herdr plugin action invoke restart --plugin herdr.auto-title`
after editing. A tab or pane you rename yourself is left alone from then on.

### herdr-radar settings live outside this repo

Its knobs are in `$(herdr plugin config-dir hhdebb.herdr-radar)/config.toml`,
not here, so they survive `configure`:

| Key | Set to | Why |
| --- | --- | --- |
| `variant` | `"font"` | skips the `fc-match` probe and uses the icon font outright |
| `group_gap` | `false` | drops the blank row radar puts after each workspace's last pane |

Others worth knowing: `group_indent` (default 2), `show_tab`, and
`activity_fresh_minutes` / `activity_stale_minutes` (15 / 120), which decide
when a pane stops reading as fresh and starts reading as abandoned.

The icons need radar's patched font as ghostty's `font-family` — see
[.config/ghostty/config](.config/ghostty/config). Without a `font-family` set
at all, text and glyphs come from different fonts with different metrics and
the logos render misaligned. Ghostty loads fonts at process start, so a new
tab is not enough after changing it.

### Two things that bite

**Plugins that write herdr's config replace the symlink instead of writing
through it.** `clauth herdr install`, and every plugin that edits
`config.toml`, can turn `~/.config/herdr/config.toml` into a regular file,
silently detaching it from this repo — edits here then do nothing and
`git status` looks clean while the live file differs. The same has happened to
`~/.claude/settings.json`. Check with `ls -la`, and restore with:

```sh
cp ~/.config/herdr/config.toml .config/herdr/config.toml   # adopt its writes
rm ~/.config/herdr/config.toml
ln -s "$PWD/.config/herdr/config.toml" ~/.config/herdr/config.toml
```

**A plugin's `[[startup]]` block runs whether you use its output or not.**
gh-checks shipped one running `--sidebar`, a poller pushing `$ci_*` tokens for
a sidebar row we never added — a background process and per-space `gh` calls
for nothing visible. It is removed from the installed manifest under
`~/.config/herdr/plugins/github/herdr-gh-checks-*/`, with a `.bak` beside it.
A plugin update restores it, since the install directory is content-hashed.

**Check what a plugin actually publishes before trusting it.** `herdr pane get
<pane_id>` lists that pane's tokens; a plugin writing none is doing nothing for
you however its rows are configured.

## Shared Themes

Herdr, Ghostty and Neovim each have to be told the theme separately, and each
names it differently. All three are on `rose-pine` today.

| Tool | File | Key |
| --- | --- | --- |
| Herdr | [.config/herdr/config.toml](.config/herdr/config.toml) | `[theme] name` |
| Ghostty | [.config/ghostty/config](.config/ghostty/config) | `theme` |
| NvChad | [.config/nvim/lua/chadrc.lua](.config/nvim/lua/chadrc.lua) | `M.base46.theme` |

Herdr is the bottleneck — it ships 17 built-in themes against Ghostty's 463 and
base46's 95. These nine are the ones where all three ports really are the same
palette, checked against the theme files rather than the names:

| Herdr | Ghostty | NvChad | |
| --- | --- | --- | --- |
| `kanagawa` | `Kanagawa Wave` | `kanagawa` | dark |
| `tokyo-night` | `TokyoNight Night` | `tokyonight` | dark |
| `gruvbox` | `Gruvbox Dark` | `gruvbox` | dark |
| `one-dark` | `Atom One Dark` | `onedark` | dark |
| `solarized` | `iTerm2 Solarized Dark` | `solarized_dark` | dark |
| `catppuccin-latte` | `Catppuccin Latte` | `catppuccin-latte` | light |
| `gruvbox-light` | `Gruvbox Light` | `gruvbox_light` | light |
| `solarized-light` | `iTerm2 Solarized Light` | `solarized_light` | light |
| `rose-pine-dawn` | `Rose Pine Dawn` | `rosepine-dawn` | light |

`kanagawa` is the cleanest of the darks — Ghostty's Kanagawa Wave and base46's
`kanagawa` agree exactly on background (`#1f1f28`), foreground (`#dcd7ba`) and
both blues.

### Named in all three, but not the same palette

These resolve everywhere, so nothing errors — the ports just drew different
colors. Worth knowing before assuming a name match is a match.

| Theme | Where it breaks |
| --- | --- |
| `vesper` | Ghostty's normal ANSI 1-6 are byte-identical to its unrelated `Mellow` theme. Background and brights do match |
| `catppuccin` | base46's port is pre-1.0 — 6 of 10 core slots are stale, including the background (`#1e1d2d` vs `#1e1e2e`). Use `catppuccin-latte` |
| `nord` | base46 maps both red and yellow to `#88c0d0`, so Nord's Aurora red and yellow never paint a token |
| `one-light` | Ghostty's `Atom One Light` has its cyan slot byte-identical to green (`#3f953a`). base46's is the correct one |
| `dracula` | base46 has no plain `dracula`, only `chadracula`, a self-declared modified version carrying neither `#ff5555` nor `#6272a4` |
| `rose-pine` | base46's `base_30` invents hues, including a green borrowed from catppuccin. The `-dawn` variant is clean |

`tokyo-night-day` and `kanagawa-lotus` exist in Herdr and Ghostty but have no
base46 counterpart at all, in any variant.

### Re-deriving the lists

The three sources, if a version bump changes what is on offer:

```sh
herdr --default-config | grep -A3 "Built-in themes"
ghostty +list-themes --plain
ls ~/.local/share/nvim/lazy/base46/lua/base46/themes/
```

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
