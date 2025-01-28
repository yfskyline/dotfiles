#!/bin/sh

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
cd /home/$SUDO_USER/dotfiles
sh dotfilesLink.sh
chsh $SUDO_USER -s $(which zsh)

# modify motd
[ -f /etc/update-motd.d/10-help-text ] && mv /etc/update-motd.d/10-help-text /etc/update-motd.d/10-help-text.orig
[ -f /etc/update-motd.d/50-motd-news ] && mv /etc/update-motd.d/50-motd-news /etc/update-motd.d/50-motd-news.orig
[ -f /etc/update-motd.d/91-contract-ua-esm-status ] && mv /etc/update-motd.d/91-contract-ua-esm-status /etc/update-motd.d/91-contract-ua-esm-status.orig
[ -f /etc/update-motd.d/90-updates-available ] && mv /etc/update-motd.d/90-updates-available /etc/update-motd.d/90-updates-available.orig
systemctl disable update-notifier-motd.timer
rm -f /var/lib/ubuntu-release-upgrader/release-upgrade-available
systemctl disable motd-news.timer
rm -f /var/cache/motd-news

# ubuntu pro
mkdir /etc/apt/apt.conf.d/old
mv /etc/apt/apt.conf.d/{,old/}20apt-esm-hook.conf
touch /etc/apt/apt.conf.d/20apt-esm-hook.conf
pro config set apt_news=false

# setup python
"$SUDO_USER"/dotfiles/setup_python.sh

# setup vim
update-alternatives --set editor /usr/bin/vim.basic
sh vim/install_NeoBundle.sh
pip install vim-vint
pip install --upgrade setuptools

sh ./ssh-keys.sh
sh cron.sh
su - $SUDO_USER -c zsh
. $SUDO_USER/dotfiles/.zshrc
