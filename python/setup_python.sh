#!/bin/bash

PYTHON_VERSION=3.13.0

# define message
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
	# install required packages
	echo -e "${LOG} installing required packages(pyenv)..."
	sudo apt update -qq
	sudo apt-get install -qq -y build-essential libssl-dev  zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
	echo -e "${LOG} installing pyenv..."
	if [ -e /home/"$TARGET_USER"/.pyenv ]; then
		echo -e "$LOG pyenv is already installed"
	else
		sudo -u "$TARGET_USER" git clone https://github.com/pyenv/pyenv.git /home/"$TARGET_USER"/.pyenv
	fi
	# sudo -u "$TARGET_USER" bash -c eval "$(pyenv init --path)"
	if sudo -u "$TARGET_USER" bash -c 'export PYENV_ROOT="$HOME/.pyenv"; export PATH="$PYENV_ROOT/bin:$PATH"; eval "$("$PYENV_ROOT/bin/pyenv" init --path)"'; then
		echo -e "$SUCCESS setuped pyenv"
	else
		echo -e "$FAILED failed to setup pyenv"
	fi
elif [ $OS = 'Mac' ]; then
	if [ "$(uname -m)" = 'x86_64' ]; then
		echo -e "${FAILED}Your platform ($(uname -a)) is not supported."
		exit 1
	else
		echo -e "${LOG} installing pyenv..."
		sudo -u "$TARGET_USER" brew install pyenv
	fi
else
	echo -e "${FAILED}Your platform ($(uname -a)) is not supported."
	exit 1
fi

if sudo -u "$TARGET_USER" bash -c 'export PYENV_ROOT="$HOME/.pyenv"; export PATH="$PYENV_ROOT/bin:$PATH"; pyenv -v'; then
	echo -e "${SUCCESS} pyenv is installed."
else
	echo -e "${FAILED} failed to install pyenv"
	exit 1
fi

# install python
sudo -u "$TARGET_USER" bash -c 'export PYENV_ROOT="$HOME/.pyenv"; export PATH="$PYENV_ROOT/bin:$PATH"; pyenv install --skip-existing '"$PYTHON_VERSION"
sudo -u "$TARGET_USER" bash -c 'export PYENV_ROOT="$HOME/.pyenv"; export PATH="$PYENV_ROOT/bin:$PATH"; pyenv global '"$PYTHON_VERSION"

# Install Linter
sudo -u "$TARGET_USER" pip install flake8
