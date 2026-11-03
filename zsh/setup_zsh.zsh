#!/usr/bin/env zsh
# One-time/per-update zplug setup; never run this from .zshrc.
set -e

if (( EUID == 0 )); then
	print -u2 'ERROR: Run setup_zsh.zsh as the target user, not root.'
	exit 1
fi

zplug_home="${ZPLUG_HOME:-$HOME/.zplug}"
if [[ ! -f "$zplug_home/init.zsh" ]]; then
	if [[ -e "$zplug_home" ]]; then
		print -u2 "ERROR: Incomplete zplug installation at $zplug_home"
		exit 1
	fi
	git clone --depth=1 https://github.com/zplug/zplug.git "$zplug_home"
fi

if [[ ! -O "$zplug_home" ]]; then
	print -u2 "ERROR: Incorrect ownership: $zplug_home"
	exit 1
fi

if ! source "$zplug_home/init.zsh"; then
	print -u2 'ERROR: Failed to initialize zplug'
	exit 1
fi

if ! source "${0:A:h}/plugins.zsh"; then
	print -u2 'ERROR: Failed to load plugins.zsh'
	exit 1
fi
if ! zplug check; then
	zplug install
fi

mkdir -p "$HOME/bin"
print 'zsh plugin setup completed.'
