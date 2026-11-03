#!/usr/bin/env zsh
# One-time/per-update zplug setup; never run this from .zshrc.
set -e

# zplug uses tput even when running without a TTY (e.g., LXD/CI).
# Keep a user-provided TERM; supply a valid terminfo entry if unset.
if [[ -z ${TERM:-} ]]; then
    export TERM=xterm-256color
fi
# Prevent Git from awaiting credentials during unattended bootstrap.
if [[ ! -t 0 ]]; then
    export GIT_TERMINAL_PROMPT=0
fi

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
    if ! zplug install; then
        # zplug may print "Installation finished successfully" but return
        # a nonzero status when a terminal UI helper such as tput fails.
        if ! zplug check; then
            print -u2 'ERROR: zplug install failed and plugins remain missing'
            exit 1
        fi
        print -u2 'WARNING: zplug install returned nonzero; all plugins verified installed'
    fi
fi
if ! zplug check; then
    print -u2 'ERROR: zplug plugins are not completely installed'
    exit 1
fi

mkdir -p "$HOME/bin"
print 'zsh plugin setup completed.'
