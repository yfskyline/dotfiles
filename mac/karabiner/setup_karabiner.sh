#!/usr/bin/env bash
set -euo pipefail

src="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
dst="$HOME/.config/karabiner"

# Validate source configuration
if [[ ! -f "$src/karabiner.json" ]]; then
    echo "ERROR: karabiner.json not found" >&2
    exit 1
fi

# Already configured
if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    echo "Karabiner is already configured"
    exit 0
fi

# Backup existing configuration
mkdir -p "$(dirname "$dst")"
if [[ -e "$dst" || -L "$dst" ]]; then
    backup="${dst}.backup.$(date +%Y%m%d-%H%M%S)"
    mv "$dst" "$backup"
    echo "Backed up: $backup"
fi

# Link dotfiles
ln -s "$src" "$dst"
echo "Linked: $dst -> $src"

# Restart Karabiner to update the configuration watcher
if command -v launchctl >/dev/null 2>&1; then
    if ! launchctl kickstart -k \
        "gui/$(id -u)/org.pqrs.service.agent.Karabiner-Console-User-Server"; then
        echo "WARNING: Restart Karabiner after installation" >&2
    fi
fi
