#!/bin/bash
# Install nvm

NODEJS_VERSION=v22.13.1

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
	echo -e "$LOG TARGET_USER=$1"
	echo -e "$LOG Setting up nvm for $TARGET_USER"
elif [ -n "$TARGET_USER" ]; then
	echo -e "$LOG Setting up nvm for $TARGET_USER"
else
	echo -e "$FAILED TARGET_USER is not set"
	echo -e "$FAILED Usage: ./setup_nvm.sh <username>"
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
	sudo -u "$TARGET_USER" brew install nvm
	sudo -u "TARGET_USER" mkdir -p /home/"$TARGET_USER"/.nvm
elif [ $OS = 'Linux' ]; then
	if sudo -u "$TARGET_USER" curl -fsSL -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash > /dev/null; then
		echo -e "$SUCCESS Setup nvm"
	else
		echo -e "$FAILED Failed to setup nvm"
		exit 1
	fi
fi

# install nodejs
sudo -u "$TARGET_USER" bash -c 'export NVM_DIR="$HOME"/.nvm; source $NVM_DIR/nvm.sh; nvm install '"$NODEJS_VERSION"
sudo -u "$TARGET_USER" bash -c 'export NVM_DIR="$HOME"/.nvm; source $NVM_DIR/nvm.sh; nvm use '"$NODEJS_VERSION"
