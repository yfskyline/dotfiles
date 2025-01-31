#!/bin/bash

# define color / log headers
RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
BLUE="\e[34;1m"
CYAN="\033[36;1m"
RESET="\e[0m"
SUCCESS="${GREEN}[SUCCESS]${RESET}"
FAILED="${RED}[FAILED ]${RESET}"
LOG="${CYAN}[LOG    ]${RESET}"

if [ "$EUID" -ne 0 ]; then
  echo -e "$FAILED Please run as root"
  exit 1
fi

echo -e "$LOG Setup timezone..."
if timedatectl set-timezone Asia/Tokyo; then
  echo -e "$SUCCESS Timezone set to Asia/Tokyo"
else
  echo -e "$FAILED Timezone set failed"
fi

echo -e "$LOG Setup apt-fast command..."
add-apt-repository -y ppa:apt-fast/stable && apt update
if apt install apt-fast -y; then
  echo -e "$SUCCESS apt-fast installed"
else
  echo -e "$FAILED apt-fast install failed"
fi

echo -e "$LOG Setup basic packages..."
if apt-fast install -y zsh curl ssh git vim tmux tig ipcalc shellcheck fd-find ripgrep jq; then
  echo -e "$SUCCESS Basic packages installed"
else
  echo -e "$FAILED Basic packages install failed"
fi
apt-fast update && sudo apt-fast upgrade -y && apt-fast autoremove -y

# setup zsh
echo -e "$LOG Setup zsh..."
cd /home/"$SUDO_USER"/dotfiles || exit 1
if sudo -u "$SUDO_USER" "$HOME"/dotfiles/dotfilesLink.sh; then
  echo -e "$SUCCESS zsh setup completed"
else
  echo -e "$FAILED zsh setup failed"
fi
if chsh "$SUDO_USER" -s "$(which zsh)"; then
  echo -e "$SUCCESS zsh setup completed"
else
  echo -e "$FAILED zsh setup failed"
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

# setup cron
echo -e "$LOG Setup cron..."
echo "*/10 * * * * cd $HOME/dotfiles/ && git pull" >> /etc/crontab

# ubuntu pro
echo -e "$LOG Setup ubuntu pro..."
mkdir /etc/apt/apt.conf.d/old
mv /etc/apt/apt.conf.d/{,old/}20apt-esm-hook.conf
touch /etc/apt/apt.conf.d/20apt-esm-hook.conf
pro config set apt_news=false

# setup git
sudo -u "$SUDO_USER" /home/"$SUDO_USER"/dotfiles/git/setup_git.sh

# setup python
echo -e "$LOG Setup python..."
if sudo -u "$SUDO_USER" /home/"$SUDO_USER"/dotfiles/python/setup_python.sh; then
  echo -e "$SUCCESS Python setup completed"
else
  echo -e "$FAILED Python setup failed"
fi

# setup vim
echo -e "$LOG Setup vim..."
update-alternatives --set editor /usr/bin/vim.basic
sudo -u "$SUDO_USER" "$SUDO_USER"vim/install_dein.sh
sudo -u "$SUDO_USER" pip install --upgrade setuptools
if sudo -u "$SUDO_USER" pip install vim-vint; then
  echo -e "$SUCCESS Vim setup completed"
else
  echo -e "$FAILED Vim setup failed"
fi

# setup nodejs
echo -e "$LOG Setup nodejs..."
if sudo -u "$SUDO_USER" /home/"$SUDO_USER"/dotfiles/nodejs/install_nvm.sh; then
  echo -e "$SUCCESS Nvm setup completed"
else
  echo -e "$FAILED Nvm setup failed"
fi
if sudo -u "$SUDO_USER" /home/"$SUDO_USER"/dotfiles/nodejs/install_yarn.sh; then
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
if sudo -u "$SUDO_USER" -c /home/"$SUDO_USER"/dotfiles/ssh/setup_authorized_keys.sh; then
  echo -e "$SUCCESS Ssh setup completed"
else
  echo -e "$FAILED Ssh setup failed"
fi

# setup docker
echo -e "$LOG Setup docker..."
if sh /home/"$SUDO_USER"/dotfiles/docker/setup_docker.sh; then
  echo -e "$SUCCESS Docker setup completed"
else
  echo -e "$FAILED Docker setup failed"
fi

sudo -u "$SUDO_USER" zsh
# shellcheck source=/home/skyline/dotfiles/.zshrc
source /home/"$SUDO_USER"/dotfiles/.zshrc
