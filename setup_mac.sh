# 
# Mac Setup script
# 
sw_vers

# システム環境設定(defaults command)
# -----------------------------------

# Dock: 自動的に隠す
defaults write com.apple.dock autohide -bool true

# マウスカーソル速度設定
defaults write "Apple Global Domain" com.apple.mouse.scaling 3.0

# MissionControl
# 最近の使用率に応じて並べ替える
defaults write com.apple.dock mru-spaces -bool true

# アプリケーションごとにウィンドウをまとめる
defaults write com.apple.dock expose-group-apps -bool true

# HotCorner
defaults write com.apple.dock wvous-tl-corner -int 13 # 画面をロック
defaults write com.apple.dock wvous-tl-modifier -int 0

# Finder:隠しファイル/フォルダを表示
defaults write com.apple.finder AppleShowAllFiles true

# Finder:拡張子を表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Dock icon size
defaults write com.apple.dock tilesize -int 39

# Automatically hide or show the Dock
defaults write com.apple.dock autohide -bool true

# Wipe all app icons from the Dock exclude Finder and Trash
defaults write com.apple.dock persistent-apps -array

# 設定を反映
killall Dock


# Finder
# Set `${HOME}` as the default location for new Finder windows
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
# ------------------------------------

xcode-select --install 

# ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# install Homebrew (パスワード入力要求されたらログインパスワード)
if [ ! -x "`which brew`" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew update
fi

# ------------------------------------
# mas-cli
# ------------------------------------
# install mas-cli
#if [ ! -x "`which mas`" ]; then
#  brew install mas
#fi
# 予めApple IDでログインしておく必要がある
#mas install 803453959 # Slack
#mas install 1333542190 # 1Password 7 (7.4.1)

# ------------------------------------



# homebrew-cask
# ------------------------------------
brew bundle

#brew cask install visual-studio-code
brew cask install karabiner-elements
brew cask install boostnote
#Interface Theme: Dark
#Editor Theme: night
# ------------------------------------



# Visual Studio Code
# ln -sf ~/dotfiles/vscode/settings.json ~/settings.json
# ln -sf ~/dotfiles/vscode/argv.json ~/.vscode/argv.json
