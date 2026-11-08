#!/usr/bin/env bash
set -o pipefail

NODEJS_VERSION="${NODEJS_VERSION:-lts/*}"
TARGET_USER="${1:-${TARGET_USER:-}}"

# Colorized log headers
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

if [[ -z "$TARGET_USER" ]]; then
	echo -e "$FAILED Usage: $0 <username>"
	exit 1
fi

if [[ "$(id -un)" != "$TARGET_USER" ]]; then
	echo -e "$FAILED Run as $TARGET_USER"
	exit 1
fi

echo -e "$LOG Setting up nvm for $TARGET_USER"
echo -e "$LOG Node.js version: $NODEJS_VERSION"

export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR" || exit 1

case "$(uname -s)" in
	Darwin)
		if [[ -s "$NVM_DIR/nvm.sh" ]]; then
			source "$NVM_DIR/nvm.sh"
		else
			NVM_SCRIPT="$(brew --prefix nvm)/nvm.sh"
			[[ -s "$NVM_SCRIPT" ]] || exit 1
			source "$NVM_SCRIPT"
		fi
		;;
	Linux)
		if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
			installer="$(mktemp)" || exit 1
			if ! curl -fsSL \
				https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh \
				-o "$installer"; then
				rm -f "$installer"
				exit 1
			fi
			if ! PROFILE=/dev/null bash "$installer"; then
				rm -f "$installer"
				exit 1
			fi
			rm -f "$installer"
		fi
		source "$NVM_DIR/nvm.sh"
		;;
	*)
		echo "Unsupported OS" >&2
		exit 1
		;;
esac

if ! nvm install "$NODEJS_VERSION"; then
	echo -e "$FAILED Node.js installation failed"
	exit 1
fi

if ! nvm alias default "$NODEJS_VERSION"; then
	echo -e "$FAILED Failed to set default Node.js"
	exit 1
fi

if ! nvm use default; then
	echo -e "$FAILED Failed to activate Node.js"
	exit 1
fi

echo -e "$SUCCESS Node.js $(node --version) available"
echo -e "$LOG npm $(npm --version)"
