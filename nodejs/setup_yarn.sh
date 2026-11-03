#!/bin/bash
# Install yarn

# define color / log headers
RED="\033[31;1m"
GREEN="\033[32;1m"
YELLOW="\033[33;1m"
BLUE="\033[34;1m"
CYAN="\033[36;1m"
RESET="\033[0m"
SUCCESS="${GREEN}[SUCCESS]${RESET}"
FAILED="${RED}[FAILED ]${RESET}"
LOG="${CYAN}[LOG    ]${RESET}"

if [ -n "$1" ]; then
	TARGET_USER=$1
	echo -e "$LOG TARGET_USER=$1"
	echo -e "$LOG Setting up yarn for $TARGET_USER"
elif [ -n "$TARGET_USER" ]; then
	echo -e "$LOG Setting up yarn for $TARGET_USER"
else
	echo -e "$FAILED TARGET_USER is not set"
	echo -e "$FAILED Usage: ./setup_yarn.sh <username>"
	exit 1
fi

# set $OS
if [ "$(uname)" = 'Darwin' ]; then
	OS='Mac'
elif [ "$(uname -s | cut -c1-5)" = 'Linux' ]; then
	OS='Linux'
elif [ "$(uname -s | cut -c1-10)" = 'MINGW32_NT' ]; then
	OS='Cygwin'
else
	echo -e "${LOG}Your platform ($(uname -a)) is not supported."
	exit 1
fi

if [ $OS = 'Mac' ]; then
	sudo -u "$TARGET_USER" bash --login -c 'brew install yarn'
elif [ $OS = 'Linux' ]; then
	# NVM bootstrap for noninteractive shells: login shells do not guarantee npm on PATH.
	TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
	if [ -z "$TARGET_HOME" ] || [ ! -f "$TARGET_HOME/.nvm/nvm.sh" ]; then
	    echo -e "${FAILED} NVM is missing for $TARGET_USER"
	    exit 1
	fi
	if ! sudo -H -u "$TARGET_USER" env NVM_DIR="$TARGET_HOME/.nvm" bash -c '
	    set -e
	    source "$NVM_DIR/nvm.sh"
	    nvm use --silent default >/dev/null
	    command -v npm >/dev/null
	    npm install --global yarn
	    yarn --version
	'; then
	    echo -e "${FAILED} Yarn setup failed"
	    exit 1
	fi
fi
