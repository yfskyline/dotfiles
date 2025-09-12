#!/bin/bash

# define color / log headers
RED="\033[31;1m"
GREEN="\033[32;1m"
YELLOW="\033[33;1m"
BLUE="\033[34;1m"
CYAN="\033[36;1m"
RESET="\033[0m"
SUCCESS="${GREEN}[SUCCESS]${RESET}"
FAILED="${RED}[FAILED ]${RESET}"
WARNING="${YELLOW}[WARNING]${RESET}"
LOG="${CYAN}[LOG    ]${RESET}"

if [ -n "$1" ]; then
	echo -e "$LOG TARGET_USER=$1"
	TARGET_USER=$1
else
	echo -e "$FAILED usage: ./install_dein.sh <username>"
fi

if [ -e /home/"$TARGET_USER"/.cache/dein  ]; then
	echo -e "$WARNING dein.vim is already installed"
	exit 0
elif [ -e /Users/$TARGET_USER/.cache/dein ]; then
	echo -e "$WARNING dein.vim is already installed"
	exit 0
else
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/Shougo/dein-installer.vim/master/installer.sh)" /home/"$TARGET_USER"/.cache/dein --use-vim-config
fi
