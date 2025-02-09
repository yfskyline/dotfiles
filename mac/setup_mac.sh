#!/bin/bash
# 
# Mac Setup script
# 

# define color / log headers
RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
BLUE="\e[34;1m"
CYAN="\e[36;1m"
RESET="\e[0m"
SUCCESS="${GREEN}[SUCCESS]${RESET}"
FAILED="${RED}[FAILED ]${RESET}"
WARNING="${YELLOW}[WARNING]${RESET}"
LOG="${CYAN}[LOG    ]${RESET}"

echo -e "${BLUE}Mac Setup Script${RESET}"

echo -e "$LOG basic dotfiles link..."
if sh "$HOME"/dotfiles/dotfilesLink.sh; then
	echo -e "$SUCCESS dotfiles setup completed"
else
	echo -e "$FAILED dotfiles setup failed"
fi

# setup git
echo -e "$LOG setup git..."
if sh "$HOME"/dotfiles/git/setup_git.sh; then
	echo -e "$SUCCESS git setup completed"
else
	echo -e "$FAILED git setup failed"
fi

# install xcode-select
echo -e "$LOG xcode-select install..."
if [ ! -x "$(xcode-select --print-path)" ]; then
	xcode-select --install
fi

# install Homebrew
echo -e "$LOG Homebrew install..."
if [ ! -x "$(which brew)" ]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo "eval '$(/opt/homebrew/bin/brew shellenv)'" >> ~/.zprofile
	eval "$(/opt/homebrew/bin/brew shellenv)"
	brew update
fi
echo -e "$LOG install Homebrew bundle packages..."
if brew bundle --file "$HOME"/dotfiles/mac/Brewfile; then
	echo -e "$SUCCESS Homebrew bundle packages installed"
else
	echo -e "$FAILED Homebrew bundle packages install failed"
fi

mkdir -p ~/dev

# setup vim
echo -e "$LOG setup vim..."
if "$HOME"/dotfiles/vim/install_dein.sh "$USER"; then
	echo -e "$SUCCESS dein.vim installed"
else
	echo -e "$FAILED dein.vim install failed"
fi
if sh "$HOME"/dotfiles/vim/setup_vim.sh; then
	echo -e "$SUCCESS vim setup completed"
else
	echo -e "$FAILED vim setup failed"
fi

# setup nodejs
echo -e "$LOG setup nvm / nodejs..."
if "$HOME"/dotfiles/nodejs/setup_nvm.sh "$USER"; then
	echo -e "$SUCCESS nvm setup completed"
else
	echo -e "$FAILED nvm setup failed"
fi
echo -e "$LOG setup yarn..."
if "$HOME"/dotfiles/nodejs/setup_yarn.sh "$USER"; then
	echo -e "$SUCCESS yarn setup completed"
else
	echo -e "$FAILED yarn setup failed"
fi

# setup scripts
sh "$HOME"/dotfiles/mac/defaults/index.sh

# CoreFoundation Preferences
killall cfprefsd
killall SystemUIServer

# open apps which are required to GUI setup
echo -e "$LOG Open apps..."
open -a "Google Chrome"
open -a "1Password 7"
open -a slack
open -a line
open -a snippety
open -a hammerspoon
open -a deepl
open -a discord
open -a zoom.us
open -a karabiner-elements

# update App Store apps
echo -e "$LOG Update App Store apps..."
softwareupdate --all --install --force

# setup ssh
echo -e "$LOG setup ssh..."
if bash "$HOME"/dotfiles/ssh/setup_ssh.sh; then
	echo -e "$SUCCESS ssh setup completed"
else
	echo -e "$FAILED ssh setup failed"
fi
if cd "$HOME" && git clone git@github.com:yfskyline/ssh-config.git && bash "$HOME"/ssh-config/configLink.sh; then
	echo -e "$SUCCESS ssh-config cloned"
else
	echo -e "$FAILED ssh-config clone failed"
fi

# setup python
if sudo bash "$HOME"/dotfiles/python/setup_python.sh "$USER"; then
	echo -e "$SUCCESS python setup completed"
else
	echo -e "$FAILED python setup failed"
fi

# display macOS version
echo -e "$LOG macOS version..."
sw_vers
