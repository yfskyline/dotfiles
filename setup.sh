#!/bin/bash

# define message
RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
BLUE="\e[34;1m"
CYAN="\e[36;1m"
RESET="\e[0m"
SUCCESS="${GREEN}[SUCCESS]${RESET}"
FAILED="${RED}[FAILED ]${RESET}"
WARNING="${YELLOW}[WARNING]${RESET}"
LOG="${CYAN}[LOG    ]${RESET}"

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

if [ "$OS" = 'Mac' ]; then
	echo -e "${LOG} Setting up for Mac"
	# check if the user is root.
	if [ "$(id -u)" -ne 0 ]; then
		echo -e "${FAILED} This script must be run as root."
		echo -e "${LOG} Usage: sudo zsh ./setup.sh"
		exit 1
	fi
	if mac/setup_mac.sh; then
		echo -e "$SUCCESS"
	else
		echo -e "$FAILED"
	fi
elif [ "$OS" = 'Linux' ]; then
	echo -e "${LOG} Setting up for Linux"
	# check if the user is root.
	if [ "$(id -u)" -ne 0 ]; then
		echo -e "${FAILED} This script must be run as root."
		echo -e "${LOG} Usage: sudo bash ./setup.sh <username>"
		exit 1
	fi

	if [ -n "$1" ]; then
		echo -e "$LOG TARGET_USER=$1"
		TARGET_USER=$1
		echo -e "$LOG Setting up for $TARGET_USER"
	elif [ -n "$TARGET_USER" ]; then
		echo -e "$LOG TARGET_USER=$TARGET_USER"
		echo -e "$LOG Setting up for $TARGET_USER"
	else
		echo -e "${FAILED} TARGET_USER is not set."
		echo -e "${FAILED} Usage: sudo bash ./setup.sh <username>"
		exit 1
	fi

	if sudo -u "$TARGET_USER" bash /home/$TARGET_USER/dotfiles/ubuntu/setup_ubuntu.sh; then
		echo -e "$SUCCESS"
	else
		echo -e "$FAILED"
	fi
fi
