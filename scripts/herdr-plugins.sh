#!/bin/bash

# Reinstall every herdr plugin. herdr has no declarative plugin list in
# config.toml, plugins live in ~/.config/herdr/plugins which is not tracked
# here, so this script is the record of what to reinstall on a new machine.
#
# Keep in sync by hand after `herdr plugin install`. To see what is currently
# installed: herdr plugin list

# owner/repo, as passed to `herdr plugin install`. The trailing comment is the
# plugin id herdr registers it under, and the version installed when this list
# was last updated (2026-08-04).
plugins=(
  cloudmanic/herdr-plus              # cloudmanic.herdr-plus     0.1.16
  gecm0/herdr-plugin-agents-usage    # gecm.agents-usage         0.1.0
  smarzban/herdr-file-viewer         # herdr-file-viewer         1.12.0
  rjyo/herdr-window-title-sync       # rjyo.window-title-sync    0.1.0
  senna-lang/herdr-agent-usage       # usagebar                  0.5.5
)

dry_run=false

usage() {
  echo "Usage: $(basename "$0") [--dry-run]"
  echo
  echo "  --dry-run  print the install commands without running them"
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

require_herdr() {
  if ! command -v herdr >/dev/null 2>&1; then
    echo "herdr not found on PATH. Install herdr first." >&2
    exit 1
  fi
}

install_plugins() {
  local failed=()

  for plugin in "${plugins[@]}"; do
    if $dry_run; then
      echo "herdr plugin install $plugin --yes"
      continue
    fi

    echo "Installing: $plugin"

    # keep going on failure so one dead repo does not strand the rest
    if ! herdr plugin install "$plugin" --yes; then
      echo "Failed: $plugin" >&2
      failed+=("$plugin")
    fi
  done

  if [ ${#failed[@]} -gt 0 ]; then
    echo
    echo "${#failed[@]} plugin(s) failed:" >&2
    printf '  %s\n' "${failed[@]}" >&2
    return 1
  fi
}

main() {
  parse_args "$@"
  require_herdr

  echo "Installing herdr plugins..."

  install_plugins || exit 1

  if ! $dry_run; then
    echo "Done. Reload with: herdr server reload-config"
  fi
}

main "$@"
