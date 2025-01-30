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
timedatectl set-timezone Asia/Tokyo

echo -e "$LOG Setup apt-fast command..."
add-apt-repository -y ppa:apt-fast/stable && apt update
apt install apt-fast -y

echo -e "$LOG Setup basic packages..."
apt-fast install -y zsh curl ssh git vim tmux tig ipcalc shellcheck fd-find ripgrep jq
apt-fast update && sudo apt-fast upgrade -y && apt-fast autoremove -y

# setup zsh
echo -e "$LOG Setup zsh..."
cd /home/"$SUDO_USER"/dotfiles || exit 1
sudo -u "$SUDO_USER" "$HOME"/dotfiles/dotfilesLink.sh
chsh "$SUDO_USER" -s "$(which zsh)"

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

# setup python
echo -e "$LOG Setup python..."
sh /home/"$SUDO_USER"/dotfiles/python/setup_python.sh

# setup vim
echo -e "$LOG Setup vim..."
update-alternatives --set editor /usr/bin/vim.basic
sh vim/install_dein.sh
pip install vim-vint
pip install --upgrade setuptools

# setup nodejs
echo -e "$LOG Setup nodejs..."
sh /home/"$SUDO_USER"/dotfiles/nodejs/install_nvm.sh
sh /home/"$SUDO_USER"/dotfiles/nodejs/install_yarn.sh

# setup ssh
echo -e "$LOG Setup ssh..."
su - "$SUDO_USER" -c /home/"$SUDO_USER"/dotfiles/ssh/setup_authorized_keys.sh

# setup docker
echo -e "$LOG Setup docker..."
sh /home/"$SUDO_USER"/dotfiles/docker/setup_docker.sh

su - "$SUDO_USER" -c zsh
# shellcheck source=/home/skyline/dotfiles/.zshrc
source /home/"$SUDO_USER"/dotfiles/.zshrc
