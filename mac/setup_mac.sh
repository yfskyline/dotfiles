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
  brew update
fi

brew bundle --file $HOME/dotfiles/mac/Brewfile

# システム環境設定(defaults command)
# -----------------------------------
# マウスカーソル速度設定
defaults write "Apple Global Domain" com.apple.mouse.scaling 3.0

# Finder:隠しファイル/フォルダを表示
defaults write com.apple.finder AppleShowAllFiles true

# Finder:拡張子を表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder
# Set `${HOME}` as the default location for new Finder windows
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
# ------------------------------------


#Interface Theme: Dark
#Editor Theme: night
# ------------------------------------

# Visual Studio Code
# ln -sf ~/dotfiles/vscode/settings.json ~/settings.json
# ln -sf ~/dotfiles/vscode/argv.json ~/.vscode/argv.json
