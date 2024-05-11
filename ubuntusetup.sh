sudo timedatectl set-timezone Asia/Tokyo
sudo add-apt-repository ppa:apt-fast/stable
sudo apt install apt-fast -y
sudo apt-fast install -y zsh curl ssh git vim tmux tig
sudo apt-fast update && sudo apt-fast upgrade -y && sudo apt-fast autoremove && sudo apt-fast cleanup
cd $HOME/dotfiles
sh dotfilesLink.sh
sudo chsh $USER -s $(which zsh)
sudo update-alternatives --set editor /usr/bin/vim.basic
sh ./ssh-keys.sh
sudo sh ./ssh-keys.sh
sudo sh NeoBundle_install.sh
sudo sh cron.sh
. $HOME/dotfiles/.zshrc
