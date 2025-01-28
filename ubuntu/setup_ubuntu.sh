#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

timedatectl set-timezone Asia/Tokyo
add-apt-repository -y ppa:apt-fast/stable && apt update
apt install apt-fast -y
apt-fast install -y zsh curl ssh git vim tmux tig ipcalc shellcheck
apt-fast update && sudo apt-fast upgrade -y && apt-fast autoremove

# setup zsh
cd /home/"$SUDO_USER"/dotfiles || exit 1
su - "$SUDO_USER" -c bash dotfilesLink.sh
chsh "$SUDO_USER" -s "$(which zsh)"

# modify motd
[ -f /etc/update-motd.d/10-help-text ] && mv /etc/update-motd.d/10-help-text /etc/update-motd.d/10-help-text.orig
[ -f /etc/update-motd.d/50-motd-news ] && mv /etc/update-motd.d/50-motd-news /etc/update-motd.d/50-motd-news.orig
[ -f /etc/update-motd.d/91-contract-ua-esm-status ] && mv /etc/update-motd.d/91-contract-ua-esm-status /etc/update-motd.d/91-contract-ua-esm-status.orig
[ -f /etc/update-motd.d/90-updates-available ] && mv /etc/update-motd.d/90-updates-available /etc/update-motd.d/90-updates-available.orig
systemctl disable update-notifier-motd.timer
rm -f /var/lib/ubuntu-release-upgrader/release-upgrade-available
systemctl disable motd-news.timer
rm -f /var/cache/motd-news

# setup cron
echo "*/10 * * * * cd $HOME/dotfiles/ && git pull" >> /etc/crontab

# ubuntu pro
mkdir /etc/apt/apt.conf.d/old
mv /etc/apt/apt.conf.d/{,old/}20apt-esm-hook.conf
touch /etc/apt/apt.conf.d/20apt-esm-hook.conf
pro config set apt_news=false

# setup python
sh /home/"$SUDO_USER"/dotfiles/python/setup_python.sh

# setup vim
update-alternatives --set editor /usr/bin/vim.basic
sh vim/install_NeoBundle.sh
pip install vim-vint
pip install --upgrade setuptools

# setup nodejs
sh /home/"$SUDO_USER"/dotfiles/nodejs/install_nvm.sh
sh /home/"$SUDO_USER"/dotfiles/nodejs/install_yarn.sh

# setup ssh
su - "$SUDO_USER" -c /home/"$SUDO_USER"/dotfiles/ssh/setup_authorized_keys.sh

# setup docker
sh /home/"$SUDO_USER"/dotfiles/docker/install_docker.sh

su - "$SUDO_USER" -c zsh
# shellcheck source=/home/skyline/dotfiles/.zshrc
source /home/"$SUDO_USER"/dotfiles/.zshrc
