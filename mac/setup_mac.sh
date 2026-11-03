#!/bin/bash
# 
# Mac Setup script
# 

# define color / log headers
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

printf "%sMac Setup Script%s\n" "${BLUE}" "${RESET}"

echo -e "$LOG basic dotfiles link..."
if sh "$HOME"/dotfiles/dotfilesLink.sh; then
	echo -e "$SUCCESS dotfiles setup completed"
else
	echo -e "$FAILED dotfiles setup failed"
fi

# setup git
echo -e "$LOG setup git..."
if sh "$HOME"/dotfiles/git/setup_git.sh "$USER"; then
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

# Setup Karabiner-Elements
echo -e "$LOG setup Karabiner-Elements..."

if bash "$HOME/dotfiles/mac/karabiner/setup_karabiner.sh"; then
	echo -e "$SUCCESS Karabiner config linked"
else
	echo -e "$FAILED Karabiner setup failed"
	exit 1
fi

# Disable automatic window tiling (macOS 15+)
if [[ $(sw_vers -productVersion | cut -d. -f1) -ge 15 ]]; then
	defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false
	defaults write com.apple.WindowManager EnableTopTilingByEdgeDrag -bool false
	defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool false
fi

# create a directory for work
mkdir -p ~/dev

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
echo -e "$LOG macOS system configuration setup scripts..."
if bash "$HOME"/dotfiles/mac/defaults/index.sh; then
	echo -e "$SUCCESS macOS system configuration setup completed"
else
	echo -e "$FAILED macOS system configuration setup failed"
fi

# CoreFoundation Preferences
killall cfprefsd
killall SystemUIServer

# update App Store apps
echo -e "$LOG Update App Store apps..."
softwareupdate --all --install --force

# setup python
if sudo bash "$HOME"/dotfiles/python/setup_python.sh "$USER"; then
	echo -e "$SUCCESS python setup completed"
else
	echo -e "$FAILED python setup failed"
fi

# setup vim
echo -e "$LOG setup vim..."
if "$HOME"/dotfiles/vim/install_dein.sh "$USER"; then
	echo -e "$SUCCESS dein.vim installed"
else
	echo -e "$FAILED dein.vim install failed"
fi

# setup SMB config
if [ -e /etc/nsmb.conf ]; then
	echo -e "$SUCCESS smb config already exists"
else
	if sudo ln -s "$HOME"/dotfiles/mac/nsmb.conf /etc/nsmb.conf; then
		echo -e "$SUCCESS smb setup completed"
	else
		echo -e "$FAILED smb setup failed"
	fi
fi

if sudo sysctl -w net.inet.tcp.delayed_ack=0; then
	echo -e "$SUCCESS smb setup (delayed_ack=0) completed"
else
	echo -e "$FAILED smb setup (delayed_ack=0) completed"
fi

# display macOS version
echo -e "$LOG macOS version..."
sw_vers

# Interactive application setup
echo -e "$LOG Interactive application setup..."
if bash "$HOME/dotfiles/mac/setup_apps.sh"; then
	echo -e "$SUCCESS Interactive application setup completed"
else
	echo -e "$FAILED Interactive application setup failed"
	exit 1
fi

# Setup SSH after 1Password onboarding
echo -e "$LOG setup ssh..."
if sudo bash "$HOME/dotfiles/ssh/setup_authorized_keys.sh"; then
	echo -e "$SUCCESS ssh setup completed"
else
	echo -e "$FAILED ssh setup failed"
	exit 1
fi

echo -e "$LOG setup ssh-config..."
if [[ -d "$HOME/ssh-config/.git" ]]; then
	echo -e "$SUCCESS ssh-config already cloned"
elif git clone git@github.com:yfskyline/ssh-config.git "$HOME/ssh-config"; then
	echo -e "$SUCCESS ssh-config cloned"
else
	echo -e "$FAILED ssh-config clone failed"
	exit 1
fi

if [[ ! -f "$HOME/ssh-config/configLink.sh" ]]; then
	echo -e "$FAILED ssh-config/configLink.sh not found"
	exit 1
elif bash "$HOME/ssh-config/configLink.sh"; then
	echo -e "$SUCCESS ssh-config setup completed"
else
	echo -e "$FAILED ssh-config setup failed"
	exit 1
fi
