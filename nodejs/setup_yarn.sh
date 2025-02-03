#!/bin/bash
# Install yarn

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
	sudo -u "$TARGET_USER" bash --login -c 'npm -g install yarn'
	sudo -u "$TARGET_USER" bash --login -c 'yarn -v'
fi
