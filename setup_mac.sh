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
# defaults write com.apple.dock wvous-tl-corner -int 5 # カーソル右上(tr)でスクリーンセイバーを開始
# defaults write com.apple.dock wvous-tl-corner -int 8 # ディスプレイをスリープ
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

# git
# ------------------------------------
git --version
#brew install git
git config --global user.name "Yuta Fukagawa"
git config --global user.email "25516089+yfskyline@users.noreply.github.com"
git config --global alias.co "checkout"
git config --global core.editor "vim"

# ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# install Homebrew (パスワード入力要求されたらログインパスワード)
if [ ! -x "`which brew`" ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew update
fi
# ------------------------------------



# mas-cli
# ------------------------------------
# install mas-cli
if [ ! -x "`which mas`" ]; then
  brew install mas
fi
# 予めApple IDでログインしておく必要がある
mas install 803453959 # Slack
mas install 539883307 # LINE
mas install 1333542190 # 1Password 7 (7.4.1)
mas install 1037126344 # Apple Configurator 2 (2.11.1)
mas install 497799835 # Xcode (11.3)
mas install 1482454543 #  Twitter (8.4.2)
mas install 1295203466 #  Microsoft Remote Desktop (10.3.7)
mas install 836500024 # WeChat (2.3.29)
mas install 904280696 # Things (3.11)
mas install 513610341 # com.peacockmedia.integrity (9.3.6)
mas install 961632517 # Be Focused Pro (1.7.5)
mas install 1025073421 #  Musicnotes (1.4)

# ------------------------------------



# homebrew-cask
# ------------------------------------
brew bundle

brew cask install virtualbox
brew cask install mactex
#brew cask install mamp

brew cask install google-chrome

brew cask install google-drive-file-stream

brew cask install visual-studio-code

brew cask install karabiner-elements

# brew cask install ccleaner

brew cask install boostnote
#Interface Theme: Dark
#Editor Theme: night
# ------------------------------------




