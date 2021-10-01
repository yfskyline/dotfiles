sudo apt install zsh
cd $HOME/dotfiles
sh dotfilesLink.sh
sudo chsh $USER -s $(which zsh)
sudo apt update && sudo apt upgrade
sudo update-alternatives --set editor /usr/bin/vim.basic
