#!/bin/sh
sudo timedatectl set-timezone Asia/Tokyo
sudo add-apt-repository ppa:apt-fast/stable
sudo apt install apt-fast -y
sudo apt-fast install -y zsh curl ssh git vim tmux tig
sudo apt-fast update && sudo apt-fast upgrade -y && sudo apt-fast autoremove && sudo apt-fast cleanup

# setup zsh
cd $HOME/dotfiles
sh dotfilesLink.sh
sudo chsh $USER -s $(which zsh)

# modify motd
[ -f /etc/update-motd.d/10-help-text ] && sudo mv /etc/update-motd.d/10-help-text /etc/update-motd.d/10-help-text.orig
[ -f /etc/update-motd.d/50-motd-news ] && sudo mv /etc/update-motd.d/50-motd-news /etc/update-motd.d/50-motd-news.orig
[ -f /etc/update-motd.d/91-contract-ua-esm-status ] && sudo mv /etc/update-motd.d/91-contract-ua-esm-status /etc/update-motd.d/91-contract-ua-esm-status.orig
[ -f /etc/update-motd.d/90-updates-available ] && sudo mv /etc/update-motd.d/90-updates-available /etc/update-motd.d/90-updates-available.orig
sudo systemctl disable update-notifier-motd.timer
sudo rm -f /var/lib/ubuntu-release-upgrader/release-upgrade-available
sudo systemctl disable motd-news.timer
sudo rm -f /var/cache/motd-news

# ubuntu pro
sudo mkdir /etc/apt/apt.conf.d/old
sudo mv /etc/apt/apt.conf.d/{,old/}20apt-esm-hook.conf
sudo touch /etc/apt/apt.conf.d/20apt-esm-hook.conf
sudo pro config set apt_news=false

# setup vim
sudo update-alternatives --set editor /usr/bin/vim.basic
sh NeoBundle_install.sh
sudo sh NeoBundle_install.sh

sh ./ssh-keys.sh
sudo sh ./ssh-keys.sh
sh cron.sh
sudo sh cron.sh
zsh
. $HOME/dotfiles/.zshrc
