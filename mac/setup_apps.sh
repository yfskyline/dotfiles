#!/usr/bin/env bash
set -euo pipefail

# Log colors
RED=$'\033[31;1m'
GREEN=$'\033[32;1m'
YELLOW=$'\033[33;1m'
CYAN=$'\033[36m'
RESET=$'\033[0m'

SUCCESS="${GREEN}[SUCCESS]${RESET}"
FAILED="${RED}[FAILED ]${RESET}"
WARNING="${YELLOW}[WARNING]${RESET}"
LOG="${CYAN}[LOG    ]${RESET}"

target="${1:-all}"
force="${2:-}"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/setup_apps"

if [[ "$force" != "" && "$force" != "--force" ]]; then
	printf '%s\n' "$FAILED Unknown option: $force" >&2
	exit 2
fi
mkdir -p "$state_dir"

# Interactive terminal is required
if ! ( : </dev/tty ) 2>/dev/null; then
	printf '%s\n' "$FAILED Interactive terminal required" >&2
	exit 1
fi

found=0

setup_app() {
	local id="$1" app="$2" instructions="$3"
	local stamp="$state_dir/$id.done"
	local answer

	[[ "$target" == "all" || "$target" == "$id" ]] || return 0
	found=1

	if [[ -f "$stamp" && "$force" != "--force" ]]; then
		printf '%s\n' "$SUCCESS $app already configured"
		return 0
	fi

	echo
	printf '%s\n' "$LOG Setup $app..."
	echo "$instructions"

	if ! open -a "$app"; then
		printf '%s\n' "$FAILED Could not open $app" >&2
		return 1
	fi

	while true; do
		printf '[Enter] completed / [s] skip / [q] quit: '
		IFS= read -r answer </dev/tty || exit 1

		case "$answer" in
			""|d|D)
				date -u '+%Y-%m-%dT%H:%M:%SZ' > "$stamp"
				printf '%s\n' "$SUCCESS $app setup completed"
				return 0
				;;
			s|S)
				printf '%s\n' "$WARNING $app setup skipped (not marked complete)"
				return 0
				;;
			q|Q)
				printf '%s\n' "$WARNING Setup interrupted by user" >&2
				exit 1
				;;
		esac
	done
}

setup_app karabiner "Karabiner-Elements" \
	"Approve macOS permissions, select ANSI, and verify key remapping."

setup_app 1password "1Password" \
	"Sign in, unlock the vault, and configure the SSH agent."

setup_app raycast "Raycast" \
	"Complete onboarding, permissions, and keyboard shortcuts."

setup_app hammerspoon "Hammerspoon" \
	"Grant Accessibility permission and verify the dotfiles configuration."

setup_app chrome "Google Chrome" \
	"Sign in and configure browser sync."

setup_app slack "Slack" \
	"Sign in to your workspaces."

setup_app line "LINE" \
	"Sign in to your account."

setup_app snippety "Snippety" \
	"Sign in and configure sync."

setup_app discord "Discord" \
	"Sign in to your account."

setup_app zoom "zoom.us" \
	"Sign in to your account."

setup_app chatgpt "ChatGPT" \
	"Sign in to your account."

setup_app notion "Notion" \
	"Sign in to your workspace."

if [[ "$found" -eq 0 ]]; then
	printf '%s\n' "$FAILED Unknown app: $target" >&2
	exit 2
fi
