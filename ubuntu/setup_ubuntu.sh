#!/bin/bash

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

if [ "$(id -u)" -ne 0 ]; then
	echo -e "$FAILED Please run as root"
	exit 1
fi
if [ -z "$SUDO_USER" ]; then
	echo -e "$WARNING SUDO_USER is not set. Falling back to root user"
	export TARGET_USER="root"
	export TARGET_HOME="/root"
	exit 1
else
	TARGET_USER="$SUDO_USER"
	TARGET_HOME="/home/$SUDO_USER"
fi


echo -e "$LOG Setup timezone..."
if timedatectl set-timezone Asia/Tokyo; then
	echo -e "$SUCCESS Timezone set to Asia/Tokyo"
else
	echo -e "$FAILED Timezone set failed"
fi

echo -e "$LOG Setup apt-fast command..."
if add-apt-repository -y ppa:apt-fast/stable; then
	echo -e "$SUCCESS apt-fast repository added"
else
	echo -e "$FAILED apt-fast repository add failed"
fi
if apt update; then
	echo -e "$SUCCESS apt-fast repository updated"
else
	echo -e "$FAILED apt-fast repository update failed"
fi
if apt install apt-fast -y; then
	echo -e "$SUCCESS apt-fast installed"
else
	echo -e "$FAILED apt-fast install failed"
fi

# dotfiles link
echo -e "$LOG basic dotfiles link..."
if sudo -u "$TARGET_USER" /home/"$TARGET_USER"/dotfiles/dotfilesLink.sh; then
	echo -e "$SUCCESS dotfiles setup completed"
else
	echo -e "$FAILED dotfiles setup failed"
	exit 1
fi

# install basic packages
echo -e "$LOG Setup basic packages..."
if apt-fast install -y zsh curl ssh git vim tmux tig ipcalc shellcheck fd-find ripgrep jq; then
	echo -e "$SUCCESS Basic packages installed"
else
	echo -e "$FAILED Basic packages install failed"
fi
echo -e "$LOG package update..."
if apt-fast update && sudo apt-fast upgrade -y && apt-fast autoremove -y; then
	echo -e "$SUCCESS package update completed"
else
	echo -e "$FAILED package update failed"
fi

# setup zsh
echo -e "$LOG chsh to zsh..."
if chsh "$TARGET_USER" -s "$(which zsh)"; then
	echo -e "$SUCCESS chsh to zsh completed"
else
	echo -e "$FAILED chsh to zsh failed"
	exit 1
fi

# modify motd
echo -e "$LOG Setup motd..."
[ -f /etc/update-motd.d/10-help-text ] && mv /etc/update-motd.d/10-help-text /etc/update-motd.d/10-help-text.orig
[ -f /etc/update-motd.d/50-motd-news ] && mv /etc/update-motd.d/50-motd-news /etc/update-motd.d/50-motd-news.orig
[ -f /etc/update-motd.d/91-contract-ua-esm-status ] && mv /etc/update-motd.d/91-contract-ua-esm-status /etc/update-motd.d/91-contract-ua-esm-status.orig
[ -f /etc/update-motd.d/90-updates-available ] && mv /etc/update-motd.d/90-updates-available /etc/update-motd.d/90-updates-available.orig
systemctl disable update-notifier-motd.timer
rm -f /var/lib/ubuntu-release-upgrader/release-upgrade-available
systemctl disable motd-news.timer
rm -f /var/cache/motd-news

# ubuntu pro
echo -e "$LOG Setup ubuntu pro..."
mkdir -p /etc/apt/apt.conf.d/old
mv /etc/apt/apt.conf.d/{,old/}20apt-esm-hook.conf
touch /etc/apt/apt.conf.d/20apt-esm-hook.conf
pro config set apt_news=false

# setup cron
echo -e "$LOG Setup cron..."
if echo "*/10 * * * * skyline cd /home/skyline/dotfiles/ && git pull" > /etc/cron.d/git_pull; then
	chown root:root /etc/cron.d/git_pull
	chmod 644 /etc/cron.d/git_pull
	echo -e "$SUCCESS Cron setup completed"
else
	echo -e "$FAILED Cron setup failed"
fi


# setup git
if sudo -u "$TARGET_USER" "$TARGET_HOME"/dotfiles/git/setup_git.sh; then
	echo -e "$SUCCESS Git setup completed"
else
	echo -e "$FAILED Git setup failed"
fi

# setup python
echo -e "$LOG Setup python..."
if sudo -u "$TARGET_USER" "$TARGET_HOME"/dotfiles/python/setup_python.sh; then
	echo -e "$SUCCESS Python setup completed"
else
	echo -e "$FAILED Python setup failed"
fi

# setup vim
echo -e "$LOG Setup vim..."
update-alternatives --set editor /usr/bin/vim.basic
echo -e "$LOG Setup vim(install dein.vim)..."
sudo -u "$TARGET_USER" "$TARGET_USER"vim/install_dein.sh
echo -e "$LOG Setup vim(install setuptools)..."
sudo -u "$TARGET_USER" pip install --upgrade setuptools
echo -e "$LOG Setup vim(install vim-vint)..."
if sudo -u "$TARGET_USER" pip install vim-vint; then
	echo -e "$SUCCESS Vim setup completed"
else
	echo -e "$FAILED Vim setup failed"
fi

# setup nodejs
echo -e "$LOG Setup nodejs..."
if sudo -u "$TARGET_USER" /home/"$TARGET_USER"/dotfiles/nodejs/setup_nodejs.sh; then
	echo -e "$SUCCESS Nvm setup completed"
else
	echo -e "$FAILED Nvm setup failed"
fi
if sudo -u "$TARGET_USER" /home/"$TARGET_USER"/dotfiles/nodejs/setup_yarn.sh; then
	echo -e "$SUCCESS Yarn setup completed"
else
	echo -e "$FAILED Yarn setup failed"
fi
if [ $? -eq 0 ]; then
	echo -e "$SUCCESS Nodejs setup completed"
else
	echo -e "$FAILED Nodejs setup failed"
fi

# setup ssh
echo -e "$LOG Setup ssh..."
if sudo -u "$TARGET_USER" "$TARGET_HOME"/dotfiles/ssh/setup_authorized_keys.sh; then
	echo -e "$SUCCESS Ssh setup completed"
else
	echo -e "$FAILED Ssh setup failed"
fi

# setup docker
echo -e "$LOG Setup docker..."
if sh "$TARGET_HOME"/dotfiles/docker/setup_docker.sh; then
	echo -e "$SUCCESS Docker setup completed"
else
	echo -e "$FAILED Docker setup failed"
fi

# sudo -u "$TARGET_USER" zsh
# shellcheck source=/home/skyline/dotfiles/.zshrc
source "$TARGET_HOME"/dotfiles/.zshrc
