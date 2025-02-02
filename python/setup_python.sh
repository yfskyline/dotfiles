#!/bin/bash

PYTHON_VERSION=3.13.1

# define message
RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
BLUE="\e[34;1m"
CYAN="\e[36;1m"
RESET="\e[0m"
SUCCESS="${GREEN}[SUCCESS]${RESET}"
FAILED="${RED}[FAILED ]${RESET}"
LOG="${CYAN}[LOG    ]${RESET}"

if [ "$(id -u)" -ne 0 ]; then
	echo -e "${FAILED}This script must be run as root."
	exit 1
fi

if [ -n "$1" ]; then
	echo -e "$LOG TARGET_USER=$1"
	TARGET_USER=$1
	echo -e "$LOG Setting up python for $1"
elif [ -n "$TARGET_USER" ]; then
	echo -e "$LOG TARGET_USER=$TARGET_USER"
	echo -e "$LOG Setting up python for $TARGET_USER"
else
	echo -e "${FAILED} TARGET_USER is not set."
	echo -e "${FAILED} Usage: ./setup_python.sh <username>"
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
	echo -e "${FAILED}Your platform ($(uname -a)) is not supported."
	exit 1
fi

# install pyenv if it has not been installed
if [ $OS = 'Linux' ]; then
	echo -e "${LOG}installing pyenv..."
	apt update
	sudo -u "$TARGET_USER" git clone https://github.com/pyenv/pyenv.git /home/"$TARGET_USER"/.pyenv
	sudo -u "$TARGET_USER" bash -c eval "$(pyenv init --path)"
elif [ $OS = 'Mac' ]; then
	if [ "$(uname -m)" = 'x86_64' ]; then
		echo -e "${FAILED}Your platform ($(uname -a)) is not supported."
		exit 1
	else
		echo -e "${LOG}installing pyenv..."
		sudo -u "$TARGET_USER" brew install pyenv
	fi
else
	echo -e "${FAILED}Your platform ($(uname -a)) is not supported."
	exit 1
fi

if sudo -u "$TARGET_USER" pyenv -v; then
	echo -e "${SUCCESS} pyenv is installed."
else
	echo -e "${FAILED} pyenv is not installed."
	exit 1
fi

# install python
sudo -u "$TARGET_USER" pyenv install $PYTHON_VERSION
sudo -u "$TARGET_USER" pyenv global $PYTHON_VERSION

# Install Linter
sudo -u "$TARGET_USER" pip install flake8
