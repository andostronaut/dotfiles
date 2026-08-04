# herdr keybinds

Notes on the herdr bindings in `.config/herdr/config.toml`. Only the ones set
here — everything unlisted keeps its herdr default, which `prefix+?` shows.

## Prefix

**`ctrl+space`** (herdr's default is `ctrl+b`).

A double-tap prefix is not possible: herdr's keybinding grammar is a single key
plus optional modifiers, with no sequence syntax. `space` alone validates but
would be unusable — the prefix key is consumed to enter prefix mode, so every
space typed in a pane would trigger it instead of inserting a space.

## Added bindings

| Key | Does | Plugin |
| --- | --- | --- |
| `prefix` `u` | provider usage modal (`r` refreshes, any other key closes) | gecm.agents-usage |
| `prefix` `shift+u` | open the limits pane, split below, focused | usagebar |
| `prefix` `shift+m` | refresh the sidebar usage meters | usagebar |
| `prefix` `shift+v` | toggle the review pane | persiyanov.reviewr |
| `prefix` `shift+l` | open the plugin manage pane | herdr-lazy |
| `prefix` `d` | open the token dashboard (own tab) | dave.token-dashboard |
| `prefix` `f` | toggle the file explorer sidebar | herdr-sidebar |
| `prefix` `shift+s` | toggle source control | herdr-sidebar |

## Why two binding types

`type = "plugin_action"` runs an action the plugin registers. Check the real
ids with `herdr plugin action list` — they rarely match the repo name
(`senna-lang/herdr-agent-usage` registers as `usagebar`,
`Davidcreador/herdr-token-dashboard` as `dave.token-dashboard`).

Plugins that support Windows register `-windows` variants of the same action.
Bind the plain id on macOS: herdr accepts the wrong one in the config and only
refuses it at the keypress, so it reads as a key that silently does nothing.

`type = "shell"` calls the herdr CLI directly, used where an action would not
do what we want:

- **`prefix+u`** — gecm.agents-usage exposes its modal as a *pane entrypoint*,
  not an action, so there is nothing to bind as `plugin_action`.
- **`prefix+shift+u`** — usagebar's own `open-limits` action hardcodes
  `--direction right`. Calling the CLI opens the same entrypoint below instead.

## Keys that were already taken

Checked against `herdr --default-config` before choosing. Occupied by herdr:

```
prefix+?  prefix+alt+g  prefix+b  prefix+c  prefix+e  prefix+g  prefix+h
prefix+j  prefix+k      prefix+l  prefix+minus  prefix+n  prefix+o  prefix+p
prefix+q  prefix+r      prefix+s  prefix+shift+d  prefix+shift+g
prefix+shift+n  prefix+shift+p  prefix+shift+r  prefix+shift+t
prefix+shift+tab  prefix+shift+w  prefix+shift+x  prefix+tab  prefix+v
prefix+w  prefix+x      prefix+z
```

Worth remembering: `prefix+l` is `focus_pane_right` and `prefix+shift+t` is
taken, which is why the manage pane and dashboard ended up on `shift+l` and `d`.

## Applying changes

```sh
herdr server reload-config     # or prefix+shift+r
herdr config check             # validates without applying
```

The config parser rejects an unknown `type` as a hard error and reports a bad
key as `invalid keybinding: …`, so `herdr config check` catches both.

`~/.config/herdr/config.toml` is a symlink to this repo, and herdr rewrites the
file itself sometimes — expect the occasional unrelated dirty line, usually
stripped alignment or a dropped comment.
