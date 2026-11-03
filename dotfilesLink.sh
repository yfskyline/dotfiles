#!/bin/bash
set -e

# set $OS
if [ "$(uname)" = 'Darwin' ]; then
	OS='Mac'
elif [ "$(uname -s | cut -c1-5)" = 'Linux' ]; then
	OS='Linux'
elif [ "$(uname -s | cut -c1-10)" = 'MINGW32_NT' ]; then
	OS='Cygwin'
else
	echo -e "${FAILED}Your platform ($(uname -a)) is not supported."
	exit 1
fi

ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.gdbinit ~/.gdbinit
ln -sf ~/dotfiles/.screenrc ~/.screenrc
ln -sf ~/dotfiles/.digrc ~/.digrc
ln -sf ~/dotfiles/git/.gitignore_global ~/.gitignore_global

# Shell configuration: machine-local wrapper
for shell in zsh bash; do
	rc="$HOME/.${shell}rc"
	shared="$HOME/dotfiles/.${shell}rc"

	if [ -e "$rc" ] || [ -L "$rc" ]; then
		if [ ! -L "$rc" ] || [ "$(readlink "$rc")" != "$shared" ]; then
			echo "Preserving existing $rc"
			continue
		fi
	fi

	tmp="$(mktemp "${rc}.XXXXXXXX")" || exit 1
	printf 'source "$HOME/dotfiles/.%src"\n' "$shell" > "$tmp"
	if [ "$shell" = "bash" ]; then
		echo '[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"' >> "$tmp"
	fi
	mv -f "$tmp" "$rc"
	echo "Configured $rc"
done

# macos
if [ $OS = 'Mac' ]; then
	# HammerSpoon config
	mkdir -p ~/.hammerspoon
	ln -sf ~/dotfiles/mac/hammerspoon/init.lua ~/.hammerspoon/init.lua

	# Visual Studio Code
	mkdir -p ~/Library/Application\ Support/Code/User/
	ln -sf ~/dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
	mkdir -p ~/.vscode
	ln -sf ~/dotfiles/vscode/argv.json ~/.vscode/argv.json
	# Interface Theme: Dark
	# Editor Theme: night
elif [ $OS = 'Linux' ]; then
	# Visual Studio Code
	mkdir -p ~/.config/Code/User/
	mkdir -p ~/.vscode
	ln -sf ~/dotfiles/vscode/settings.json ~/.config/Code/User/settings.json
	ln -sf ~/dotfiles/vscode/argv.json ~/.vscode/argv.json
	# Interface Theme: Dark
	# Editor Theme: night
	#ssh-import-id gh:yfskyline
else
	echo -e "${FAILED}Your platform ($(uname -a)) is not supported."
	exit 1
fi
