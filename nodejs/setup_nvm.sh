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
	mkdir -p "$HOME"/.nvm
elif [ $OS = 'Linux' ]; then
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi
