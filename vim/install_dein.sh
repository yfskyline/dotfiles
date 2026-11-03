#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 || "${1}" != "$(id -un)" ]]; then
	printf 'ERROR: Run as the target user: bash install_dein.sh <current-username>\n' >&2
	exit 1
fi

if [[ -d "$HOME/.cache/dein" ]]; then
	printf 'dein.vim is already installed\n'
	exit 0
fi

mkdir -p "$HOME/.cache"
curl -fsSL https://raw.githubusercontent.com/Shougo/dein-installer.vim/master/installer.sh | sh -s "$HOME/.cache/dein" --use-vim-config
