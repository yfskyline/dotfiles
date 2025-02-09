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
if [ ! -x "$(xcode-select --print-path)" ]; then
	xcode-select --install
fi

# install Homebrew
if [ ! -x "$(which brew)" ]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo "eval '$(/opt/homebrew/bin/brew shellenv)'" >> ~/.zprofile
	eval "$(/opt/homebrew/bin/brew shellenv)"
	brew update
fi

brew bundle --file "$HOME"/dotfiles/mac/Brewfile


mkdir -p ~/dev

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

# display macOS version
echo -e "$LOG macOS version..."
sw_vers
