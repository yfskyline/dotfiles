#!/bin/bash

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
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
#ssh-import-id gh:yfskyline
ln -sf ~/dotfiles/.screenrc ~/.screenrc
ln -sf ~/dotfiles/.digrc ~/.digrc
ln -sf ~/dotfiles/git/.gitignore_global ~/.gitignore_global

# macos
if [ $OS = 'Mac' ]; then
	# Karabiner-Elements config
	mkdir -p ~/.config/karabiner
	ln -sf ~/dotfiles/mac/karabiner/assets ~/.config/karabiner/assets
	ln -sf ~/dotfiles/mac/karabiner/karabiner.json ~/.config/karabiner/karabiner.json

	# Visual Studio Code
	mkdir -p ~/Library/Application\ Support/Code/User/
	ln -sf ~/dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
	mkdir -p ~/.vscode
	ln -sf ~/dotfiles/vscode/argv.json ~/.vscode/argv.json
	# Interface Theme: Dark
	# Editor Theme: night
elif [ $OS = 'Linux' ]; then
	# Visual Studio Code
	ln -sf ~/dotfiles/vscode/settings.json ~/.config/Code/User/settings.json
	ln -sf ~/dotfiles/vscode/argv.json ~/.vscode/argv.json
	# Interface Theme: Dark
	# Editor Theme: night
else
	echo -e "${FAILED}Your platform ($(uname -a)) is not supported."
	exit 1
fi
