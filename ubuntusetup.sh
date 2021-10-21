sudo apt install zsh
cd $HOME/dotfiles
sh dotfilesLink.sh
sudo chsh $USER -s $(which zsh)
sudo apt update && sudo apt upgrade -y && sudo apt autoremove
sudo update-alternatives --set editor /usr/bin/vim.basic
source $HOME/dotfiles/.zshrc
