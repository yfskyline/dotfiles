#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 || "${1:-}" != "$(id -un)" ]]; then
	printf 'ERROR: Run as the target user: bash install_dein.sh <current-username>\n' >&2
	exit 1
fi

DEIN_REPO_DIR="$HOME/.cache/dein/repos/github.com/Shougo/dein.vim"

# Already installed
if [[ -d "$DEIN_REPO_DIR/.git" ]]; then
	printf 'dein.vim is already installed: %s\n' "$DEIN_REPO_DIR"
	exit 0
fi

# Do not overwrite an incomplete installation automatically
if [[ -e "$DEIN_REPO_DIR" || -L "$DEIN_REPO_DIR" ]]; then
	printf 'ERROR: Existing directory is not a valid Git clone: %s\n' "$DEIN_REPO_DIR" >&2
	exit 1
fi

# Install dein.vim without modifying ~/.vimrc
mkdir -p "$(dirname "$DEIN_REPO_DIR")"

git clone --depth 1 \
	https://github.com/Shougo/dein.vim.git \
	"$DEIN_REPO_DIR"

printf 'dein.vim installed: %s\n' "$DEIN_REPO_DIR"
