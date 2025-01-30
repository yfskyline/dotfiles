#!/bin/bash
# Install nvm

# set $OS
OS_NAME=$(uname -s)
if [ "$OS_NAME" = 'Darwin' ]; then
	OS='Mac'
elif [ "${OS_NAME:0:5}" = 'Linux' ]; then
	OS='Linux'
elif [ "${OS_NAME:0:10}" = 'MINGW32_NT' ]; then
	OS='Cygwin'
else
	echo -e "${LOG}Your platform ($(uname -a)) is not supported."
	exit 1
fi

if [ $OS = 'Mac' ]; then
	brew install nvm
	mkdir "$HOME"/.nvm
elif [ $OS = 'Linux' ]; then
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi
