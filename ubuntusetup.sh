sudo apt install -y zsh curl ssh git
cd $HOME/dotfiles
sh dotfilesLink.sh
sudo chsh $USER -s $(which zsh)
sudo apt update && sudo apt upgrade -y && sudo apt autoremove
sudo update-alternatives --set editor /usr/bin/vim.basic
sudo sh ./ssh-keys.sh
sudo sh cron.sh
source $HOME/dotfiles/.zshrc
