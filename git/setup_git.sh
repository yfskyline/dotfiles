#!/bin/bash

if [ -n "$1" ]; then
	TARGET_USER=$1
	echo "TARGET_USER=$1"
	echo "Setting up git..."
elif [ -n "$TARGET_USER" ]; then
	TARGET_USER=$USER
	echo "TARGET_USER=$TARGET_USER"
	echo "Setting up git..."
else
	echo "TARGET_USER is not set"
	echo "Usage: ./setup_git.sh <username>"
	exit 1
fi

git config --global user.name "Yuta Fukagawa"
git config --global user.email 25516089+yfskyline@users.noreply.github.com
git config --global core.editor vim
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto
git config --global pull.ff only
git config --global pull.rebase true
git config --global fetch.prune true
git config --list

# set $OS
if [ "$(uname)" = 'Darwin' ]; then
	OS='Mac'
	mkdir -p ~/.config/git && cp /Users/"$TARGET_USER"/dotfiles/git/.gitignore_global /Users/"$TARGET_USER"/.config/git/ignore
elif [ "$(uname -s | cut -c1-5)" = 'Linux' ]; then
	OS='Linux'
	mkdir -p ~/.config/git && cp /home/"$TARGET_USER"/dotfiles/git/.gitignore_global /home/"$TARGET_USER"/.config/git/ignore
elif [ "$(uname -s | cut -c1-10)" = 'MINGW32_NT' ]; then
	OS='Cygwin'
else
	echo -e "${FAILED}Your platform ($(uname -a)) is not supported."
	exit 1
fi
