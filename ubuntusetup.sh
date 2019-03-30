cd
sudo apt install zsh
git clone https://github.com/yfskyline/dotfiles.git
cd
cd dotfiles
sh dotfilesLink.sh
sudo chsh $USER -s $(which zsh)
