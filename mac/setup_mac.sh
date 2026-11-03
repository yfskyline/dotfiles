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
if bash "$HOME"/dotfiles/dotfilesLink.sh; then
	echo -e "$SUCCESS dotfiles setup completed"
else
	echo -e "$FAILED dotfiles setup failed"
	exit 1
fi

# setup git
echo -e "$LOG setup git..."
if bash "$HOME"/dotfiles/git/setup_git.sh "$USER"; then
	echo -e "$SUCCESS git setup completed"
else
	echo -e "$FAILED git setup failed"
	exit 1
fi

# install Xcode Command Line Tools
echo -e "$LOG Check Xcode Command Line Tools..."

if ! xcrun --find clang > /dev/null 2>&1; then
	if ! xcode-select --install; then
		echo -e "$FAILED Xcode Command Line Tools installation request failed"
		exit 1
	fi

	echo -e "$WARNING Complete Xcode Command Line Tools installation and rerun setup.sh"
	exit 1
fi

echo -e "$SUCCESS Xcode Command Line Tools available"

# install Homebrew
echo -e "$LOG Homebrew install..."

brew_bin="$(command -v brew 2>/dev/null || true)"
if [ -z "$brew_bin" ]; then
	for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
		if [ -x "$candidate" ]; then
			brew_bin="$candidate"
			break
		fi
	done
fi

brew_installed=0
if [ -z "$brew_bin" ]; then
	if ! install_script="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
		echo -e "$FAILED Homebrew installer download failed"
		exit 1
	fi

	if ! /bin/bash -c "$install_script"; then
		echo -e "$FAILED Homebrew installation failed"
		exit 1
	fi

	brew_installed=1
	for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
		if [ -x "$candidate" ]; then
			brew_bin="$candidate"
			break
		fi
	done
fi

if [ -z "$brew_bin" ] || [ ! -x "$brew_bin" ]; then
	echo -e "$FAILED Homebrew executable not found"
	exit 1
fi

if ! brew_env="$("$brew_bin" shellenv)"; then
	echo -e "$FAILED Homebrew environment setup failed"
	exit 1
fi
eval "$brew_env"

brew_profile_line="eval \"\$($brew_bin shellenv)\""
if ! /usr/bin/grep -Fq 'HOMEBREW_PREFIX=' "$HOME/.zprofile" 2>/dev/null &&
	! /usr/bin/grep -Fqx "$brew_profile_line" "$HOME/.zprofile" 2>/dev/null; then
	if ! printf '\n%s\n' "$brew_profile_line" >> "$HOME/.zprofile"; then
		echo -e "$FAILED Homebrew profile setup failed"
		exit 1
	fi
fi

if [ "$brew_installed" -eq 1 ]; then
	if ! "$brew_bin" update; then
		echo -e "$FAILED Homebrew update failed"
		exit 1
	fi
fi

echo -e "$LOG install Homebrew bundle packages..."
if brew bundle --file "$HOME/dotfiles/mac/Brewfile"; then
	echo -e "$SUCCESS Homebrew bundle packages installed"
else
	echo -e "$FAILED Homebrew bundle packages install failed"
	exit 1
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
macos_major="$(sw_vers -productVersion | cut -d. -f1)" || exit 1
if [ "$macos_major" -ge 15 ]; then
	if ! defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false ||
		! defaults write com.apple.WindowManager EnableTopTilingByEdgeDrag -bool false ||
		! defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool false; then
		echo -e "$FAILED Window tiling configuration failed"
		exit 1
	fi
fi

# Create a directory for work
if ! mkdir -p "$HOME/dev"; then
	echo -e "$FAILED ~/dev creation failed"
	exit 1
fi

# setup nodejs
echo -e "$LOG setup nvm / nodejs..."
if "$HOME"/dotfiles/nodejs/setup_nvm.sh "$USER"; then
	echo -e "$SUCCESS nvm setup completed"
else
	echo -e "$FAILED nvm setup failed"
	exit 1
fi
echo -e "$LOG setup yarn..."
if "$HOME"/dotfiles/nodejs/setup_yarn.sh "$USER"; then
	echo -e "$SUCCESS yarn setup completed"
else
	echo -e "$FAILED yarn setup failed"
	exit 1
fi

# setup scripts
echo -e "$LOG macOS system configuration setup scripts..."
if bash "$HOME/dotfiles/mac/defaults/index.sh"; then
	echo -e "$SUCCESS macOS system configuration setup completed"
else
	echo -e "$FAILED macOS system configuration setup failed"
	exit 1
fi

# CoreFoundation Preferences
killall cfprefsd 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

# macOS software updates (opt-in)
if [ "${UPDATE_MACOS:-0}" = "1" ]; then
	echo -e "$LOG Update macOS..."
	if ! softwareupdate --all --install --force; then
		echo -e "$FAILED macOS software update failed"
		exit 1
	fi
else
	echo -e "$LOG Skipping macOS software updates"
fi

# setup python
if sudo bash "$HOME/dotfiles/python/setup_python.sh" "$USER"; then
	echo -e "$SUCCESS python setup completed"
else
	echo -e "$FAILED python setup failed"
	exit 1
fi

# setup vim
echo -e "$LOG setup vim..."
if bash "$HOME/dotfiles/vim/install_dein.sh" "$USER"; then
	echo -e "$SUCCESS dein.vim installed"
else
	echo -e "$FAILED dein.vim install failed"
	exit 1
fi

# Setup SMB config
if [ -L /etc/nsmb.conf ] && [ ! -e /etc/nsmb.conf ]; then
	echo -e "$FAILED /etc/nsmb.conf is a broken symlink"
	exit 1
elif [ -e /etc/nsmb.conf ]; then
	echo -e "$SUCCESS SMB config already exists"
elif sudo ln -s "$HOME/dotfiles/mac/nsmb.conf" /etc/nsmb.conf; then
	echo -e "$SUCCESS SMB config linked"
else
	echo -e "$FAILED SMB config setup failed"
	exit 1
fi

if sudo sysctl -w net.inet.tcp.delayed_ack=0; then
	echo -e "$SUCCESS SMB setup (delayed_ack=0) completed"
else
	echo -e "$FAILED SMB setup (delayed_ack=0) failed"
	exit 1
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
