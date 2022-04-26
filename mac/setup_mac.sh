# 
# Mac Setup script
# 
sw_vers

sh $HOME/dotfiles/mac/dotfilesLink.sh

# Karabiner-Elements config
mkdir -p ~/.config
ln -sf ~/dotfiles/mac/karabiner ~/.config/karabiner

xcode-select --install 

# install Homebrew
if [ ! -x "`which brew`" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
  brew update
fi
brew update
brew bundle --file $HOME/dotfiles/mac/Brewfile

#Interface Theme: Dark
#Editor Theme: night
# ------------------------------------

# Visual Studio Code
# ln -sf ~/dotfiles/vscode/settings.json ~/settings.json
# ln -sf ~/dotfiles/vscode/argv.json ~/.vscode/argv.json

mkdir -p ~/dev

# CoreFoundation Preferences
killall cfprefsd
killall SystemUIServer

open -a "Google Chrome"
open -a "1Password 7"
open -a slack
