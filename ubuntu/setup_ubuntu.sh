#!/bin/bash

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

if [ "$(id -u)" -ne 0 ]; then
	echo -e "$FAILED Please run as root"
	exit 1
fi
if [ -z "${SUDO_USER:-}" ] || [ "$SUDO_USER" = "root" ]; then
	echo -e "$FAILED Run this script using sudo from a normal user."
	exit 1
fi

TARGET_USER="$SUDO_USER"
TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

if [ -z "$TARGET_HOME" ] || [ ! -d "$TARGET_HOME" ]; then
	echo -e "$FAILED Cannot determine home directory for $TARGET_USER"
	exit 1
fi
echo -e "$LOG TARGET_USER: $TARGET_USER"
echo -e "$LOG TARGET_HOME: $TARGET_HOME"


echo -e "$LOG Setup timezone..."
if timedatectl set-timezone Asia/Tokyo; then
	echo -e "$SUCCESS Timezone set to Asia/Tokyo"
else
	echo -e "$FAILED Timezone set failed"
	exit 1
fi

# Non-interactive, distribution-provided APT (Ubuntu 22.04/24.04/26.04).
# apt-fast's debconf wizard blocks unattended bootstrap; no third-party PPA.
export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none
export NEEDRESTART_MODE=a

# Keep existing locally modified package configuration files by default.
apt_get() {
    apt-get -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold "$@"
}

echo -e "$LOG Updating Ubuntu APT package index..."
if apt_get update -qq; then
    echo -e "$SUCCESS APT package index updated"
else
    echo -e "$FAILED APT package index update failed"
    exit 1
fi

# dotfiles link
echo -e "$LOG basic dotfiles link..."
if sudo -H -u "$TARGET_USER" bash "$TARGET_HOME/dotfiles/dotfilesLink.sh"; then
	echo -e "$SUCCESS dotfiles setup completed"
else
	echo -e "$FAILED dotfiles setup failed"
	exit 1
fi

# setup sudo
sudoers_tmp="$(mktemp)" || exit 1

if sed "s/^skyline ALL=/$TARGET_USER ALL=/" \
	"$TARGET_HOME/dotfiles/ubuntu/z99-skyline-nopasswd" > "$sudoers_tmp" \
	&& visudo -cf "$sudoers_tmp" > /dev/null \
	&& install -m 0440 -o root -g root "$sudoers_tmp" /etc/sudoers.d/z99-skyline-nopasswd; then
	echo -e "$SUCCESS sudoers setup completed"
else
	echo -e "$FAILED sudoers setup failed"
	rm -f "$sudoers_tmp"
	exit 1
fi

rm -f "$sudoers_tmp"

# install basic packages
echo -e "$LOG Setup basic packages..."
if apt_get install -qq -y zsh curl ssh git vim tmux tig ipcalc shellcheck fd-find ripgrep jq ipmitool whois pipx python3-setuptools gawk; then
	echo -e "$SUCCESS Basic packages installed"
else
	echo -e "$FAILED Basic packages install failed"
	exit 1
fi
# OS-wide upgrades must be explicitly requested.
if [ "${UPDATE_UBUNTU:-0}" = "1" ]; then
	echo -e "$LOG Ubuntu package upgrade (opt-in)..."
	if ! apt_get update -qq || ! apt_get upgrade -qq -y || ! apt_get autoremove -qq -y; then
		echo -e "$FAILED Ubuntu package upgrade failed"
		exit 1
	fi
else
	echo -e "$LOG Skipping Ubuntu package upgrades"
fi

# Setup zsh plugins as the target user
if ! sudo -H -u "$TARGET_USER" zsh "$TARGET_HOME/dotfiles/zsh/setup_zsh.zsh"; then
	echo -e "$FAILED zsh plugin setup failed"
	exit 1
fi
# setup zsh
echo -e "$LOG chsh to zsh..."
if grep -q "^$TARGET_USER:" /etc/passwd; then
	zsh_path="$(command -v zsh)"
	current_shell="$(getent passwd "$TARGET_USER" | cut -d: -f7)"
	if [ "$current_shell" = "$zsh_path" ]; then
		echo -e "$SUCCESS Login shell already set to zsh"
	elif chsh "$TARGET_USER" -s "$zsh_path"; then
		echo -e "$SUCCESS chsh to zsh completed"
	else
		echo -e "$FAILED chsh to zsh failed"
		exit 1
	fi
else
	echo -e "$WARNING User '$TARGET_USER' not found in /etc/passwd (Likely LDAP account)."
	echo -e "$WARNING Skipping chsh..."
fi
echo -e "$LOG Current shell: $SHELL"

# Disable unwanted MOTD entries without overwriting existing backups.
echo -e "$LOG Setup motd..."
for motd_name in 10-help-text 50-motd-news 91-contract-ua-esm-status 90-updates-available; do
	motd_path="/etc/update-motd.d/$motd_name"
	if [ -f "$motd_path" ] && [ ! -e "${motd_path}.orig" ]; then
		if ! mv "$motd_path" "${motd_path}.orig"; then
			echo -e "$FAILED Failed to disable $motd_name"
			exit 1
		fi
	fi
done
systemctl disable update-notifier-motd.timer 2>/dev/null || true
systemctl disable motd-news.timer 2>/dev/null || true
rm -f /var/lib/ubuntu-release-upgrader/release-upgrade-available /var/cache/motd-news

# Ubuntu Pro: do not modify apt hooks manually.
echo -e "$LOG Setup ubuntu pro..."
if command -v pro > /dev/null 2>&1; then
	if ! pro config set apt_news=false; then
		echo -e "$WARNING Unable to disable Ubuntu Pro apt news"
	fi
fi

# setup cron
echo -e "$LOG Setup cron..."
cron_tmp="$(mktemp /etc/cron.d/.dotfiles-git-pull.XXXXXX)" || exit 1
if printf '*/10 * * * * %s cd "%s/dotfiles" && /usr/bin/git pull --ff-only\n' "$TARGET_USER" "$TARGET_HOME" > "$cron_tmp" \
	&& chmod 0644 "$cron_tmp" \
	&& chown root:root "$cron_tmp" \
	&& mv -f "$cron_tmp" /etc/cron.d/git_pull; then
	echo -e "$SUCCESS Cron setup completed"
else
	echo -e "$FAILED Cron setup failed"
	rm -f "$cron_tmp"
	exit 1
fi


# setup git
echo -e "$LOG Setup git..."
if sudo -H -u "$TARGET_USER" bash "$TARGET_HOME/dotfiles/git/setup_git.sh" "$TARGET_USER"; then
	echo -e "$SUCCESS Git setup completed"
else
	echo -e "$FAILED Git setup failed"
	exit 1
fi

# setup python
echo -e "$LOG Setup python..."
if HOME="$TARGET_HOME" bash "$TARGET_HOME"/dotfiles/python/setup_python.sh "$TARGET_USER"; then
	echo -e "$SUCCESS Python setup completed"
else
	echo -e "$FAILED Python setup failed"
	exit 1
fi

# setup vim
echo -e "$LOG Setup vim..."
if ! update-alternatives --set editor /usr/bin/vim.basic; then
	echo -e "$FAILED Setting vim as editor failed"
	exit 1
fi
echo -e "$LOG Setup vim(install dein.vim)..."
if sudo -H -u "$TARGET_USER" bash "$TARGET_HOME/dotfiles/vim/install_dein.sh" "$TARGET_USER"; then
	echo -e "$SUCCESS Dein.vim setup completed"
else
	echo -e "$FAILED Dein.vim setup failed"
	exit 1
fi
# Use pipx instead of modifying Ubuntu's system Python environment.
echo -e "$LOG Setup vim-vint via pipx..."
if [ -x "$TARGET_HOME/.local/bin/vint" ]; then
	echo -e "$SUCCESS vim-vint already installed"
elif sudo -H -u "$TARGET_USER" pipx install vim-vint; then
	echo -e "$SUCCESS vim-vint installed"
else
	echo -e "$FAILED vim-vint install failed"
	exit 1
fi

# setup nodejs
echo -e "$LOG Setup nodejs..."
if sudo -u "$TARGET_USER" "$TARGET_HOME"/dotfiles/nodejs/setup_nvm.sh "$TARGET_USER"; then
	echo -e "$SUCCESS Nvm setup completed"
else
	echo -e "$FAILED Nvm setup failed"
	exit 1
fi
if sudo -u "$TARGET_USER" "$TARGET_HOME"/dotfiles/nodejs/setup_yarn.sh "$TARGET_USER"; then
	echo -e "$SUCCESS Yarn setup completed"
else
	echo -e "$FAILED Yarn setup failed"
	exit 1
fi
echo -e "$SUCCESS Nodejs setup completed"

# setup ssh
echo -e "$LOG Setup ssh..."
if bash "$TARGET_HOME"/dotfiles/ssh/setup_authorized_keys.sh "$TARGET_USER"; then
	echo -e "$SUCCESS SSH setup completed"
else
	echo -e "$FAILED SSH setup failed"
	exit 1
fi

# setup docker
echo -e "$LOG Setup docker..."
if bash "$TARGET_HOME"/dotfiles/docker/setup_docker.sh "$TARGET_USER"; then
	echo -e "$SUCCESS Docker setup completed"
else
	echo -e "$FAILED Docker setup failed"
	exit 1
fi

# sudo -u "$TARGET_USER" zsh
# shellcheck source=/home/skyline/dotfiles/.zshrc
# zsh -i source "$TARGET_HOME"/dotfiles/.zshrc && exit 0
if ! sudo -H -u "$TARGET_USER" zsh -i -c 'exit 0'; then
	echo -e "$FAILED Zsh startup test failed"
	exit 1
fi
