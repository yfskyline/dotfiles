#!/bin/bash
# Install nvm

# define color / log headers
RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
BLUE="\e[34;1m"
CYAN="\033[36;1m"
RESET="\e[0m"
SUCCESS="${GREEN}[SUCCESS]${RESET}"
FAILED="${RED}[FAILED ]${RESET}"
LOG="${CYAN}[LOG    ]${RESET}"

if [ -n "$1" ]; then
	TARGET_USER=$1
	echo "$LOG TARGET_USER=$1"
	echo "$LOG Setting up nvm for $TARGET_USER"
elif [ -n "$TARGET_USER" ]; then
	echo "$LOG Setting up nvm for $TARGET_USER"
else
	echo "$FAILED TARGET_USER is not set"
	echo "$FAILED Usage: ./setup_nvm.sh <username>"
	exit 1
fi

# set $OS
OS_NAME=$(uname -s)
if [ "$OS_NAME" = 'Darwin' ]; then
	OS='Mac'
elif [ "${OS_NAME:0:5}" = 'Linux' ]; then
	OS='Linux'
elif [ "${OS_NAME:0:10}" = 'MINGW32_NT' ]; then
	OS='Cygwin'
else
	echo -e "${FAILED}Your platform ($(uname -a)) is not supported."
	exit 1
fi

if [ $OS = 'Mac' ]; then
	brew install nvm
	mkdir -p /home/"$TARGET_USER"/.nvm
elif [ $OS = 'Linux' ]; then
	sudo -u "$TARGET_USER" curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi
