#!/bin/bash
set -euo pipefail

# Log messages
RED="\033[31;1m"
GREEN="\033[32;1m"
YELLOW="\033[33;1m"
CYAN="\033[36;1m"
RESET="\033[0m"

SUCCESS="${GREEN}[SUCCESS]${RESET}"
FAILED="${RED}[FAILED ]${RESET}"
WARNING="${YELLOW}[WARNING]${RESET}"
LOG="${CYAN}[LOG    ]${RESET}"

# Options
DRY_RUN=0
if [ "${1:-}" = "--dry-run" ]; then
	DRY_RUN=1
	shift
fi

if [ "$#" -ne 0 ]; then
	printf '%b\n' "${FAILED} Usage: bash setup.sh [--dry-run]" >&2
	exit 2
fi

# Do not run the entire setup as root
if [ "$(id -u)" -eq 0 ]; then
	printf '%b\n' "${FAILED} Run as a normal user, not root." >&2
	exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect OS and select setup script
case "$(uname -s)" in
	Darwin)
		OS="macOS"
		CMD=(bash "$SCRIPT_DIR/mac/setup_mac.sh")
		;;
	Linux)
		if [ ! -r /etc/os-release ]; then
			printf '%b\n' "${FAILED} Cannot identify Linux distribution." >&2
			exit 1
		fi
		. /etc/os-release
		if [ "${ID:-}" != "ubuntu" ]; then
			printf '%b\n' "${FAILED} Unsupported Linux distribution: ${ID:-unknown}" >&2
			exit 1
		fi

		OS="Ubuntu"
		CMD=(sudo bash "$SCRIPT_DIR/ubuntu/setup_ubuntu.sh")
		;;
	*)
		printf '%b\n' "${FAILED} Unsupported OS: $(uname -s)" >&2
		exit 1
		;;
esac

printf '%b\n' "${LOG} Setting up for $OS"

# Preview execution without making changes
if [ "$DRY_RUN" -eq 1 ]; then
	printf '%b\n' "${LOG} Dry-run: no changes will be made."
	printf 'Command:'
	printf ' %q' "${CMD[@]}"
	printf '\n'
	exit 0
fi

# Execute platform-specific setup
if "${CMD[@]}"; then
	printf '%b\n' "${SUCCESS} $OS setup completed."
else
	STATUS=$?
	printf '%b\n' "${FAILED} $OS setup failed (exit status: $STATUS)." >&2
	exit "$STATUS"
fi
