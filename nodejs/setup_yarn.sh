#!/bin/bash
# Install yarn

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
	brew install yarn
elif [ $OS = 'Linux' ]; then
	npm -g install yarn
	yarn -v
fi
