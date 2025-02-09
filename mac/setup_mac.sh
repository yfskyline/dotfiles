#!/bin/bash
# 
# Mac Setup script
# 

sh "$HOME"/dotfiles/mac/dotfilesLink.sh
sh "$HOME"/dotfiles/setup_git.sh
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

# Karabiner-Elements config
mkdir -p ~/.config/karabiner
ln -sf ~/dotfiles/mac/karabiner/assets ~/.config/karabiner/assets
ln -sf ~/dotfiles/mac/karabiner/karabiner.json ~/.config/karabiner/karabiner.json
echo -e "${BLUE}Mac Setup Script${RESET}"


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

# Interface Theme: Dark
# Editor Theme: night
# ------------------------------------

# Visual Studio Code
# ln -sf ~/dotfiles/vscode/settings.json ~/settings.json
# ln -sf ~/dotfiles/vscode/argv.json ~/.vscode/argv.json

mkdir -p ~/dev

# setup scripts
sh "$HOME"/dotfiles/mac/defaults/index.sh

# CoreFoundation Preferences
killall cfprefsd
killall SystemUIServer

open -a "Google Chrome"
open -a "1Password 7"
open -a slack
open -a line
open -a snippety
open -a hammerspoon
open -a deepl
open -a discord
open -a firefox
open -a zoom.us
open -a karabiner-elements

softwareupdate --all --install --force

# display macOS version
echo -e "$LOG macOS version..."
sw_vers
