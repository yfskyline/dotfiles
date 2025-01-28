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

# set $OS
if [ "$(uname)" = 'Darwin' ]; then
	OS='Mac'
elif [ "$(expr substr $(uname -s) 1 5)" = 'Linux' ]; then
	OS='Linux'
elif [ "$(expr substr $(uname -s) 1 10)" = 'MINGW32_NT' ]; then
	OS='Cygwin'
else
	echo -e "${FAILED}Your platform ($(uname -a)) is not supported."
	exit 1
fi

# install pyenv if it has not been installed
if [ $OS = 'Linux' ]; then
	echo -e "${LOG}installing pyenv..."
	sudo apt update
	git clone https://github.com/pyenv/pyenv.git ~/.pyenv
	eval "$(pyenv init --path)"
elif [ $OS = 'Mac' ]; then
	if [ "$(uname -m)" = 'x86_64' ]; then
		echo -e "${FAILED}Your platform ($(uname -a)) is not supported."
		exit 1
	else
		echo -e "${LOG}installing pyenv..."
		brew install pyenv
	fi
else
	echo -e "${FAILED}Your platform ($(uname -a)) is not supported."
	exit 1
fi
pyenv -v
echo -e "${SUCCESS}Successfully pyenv installed."

# install python
pyenv install $PYTHON_VERSION
pyenv global $PYTHON_VERSION

# Install Linter
pip install flake8
