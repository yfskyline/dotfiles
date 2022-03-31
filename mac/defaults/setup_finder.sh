#!/bin/bash

# show hidden files in finder
# defaults write com.apple.finder AppleShowAllFiles YES

# Automatically open a new Finder window whe a volume is mounted
# defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
# defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
# defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Set `${HOME}` as the default location for new Finder windows
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Show Status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Show Path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show Tab bar in Finder
defaults write com.apple.finder ShowTabView -bool true

# Show the ~/Library directory
chflags nohidden ~/Library

# Show files extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Avoid creating `.DS_Store` files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Search within seeing directory
defaults write com.apple.finder FXDefaultSearchScope -string SCcf

## 未確認ファイルを開くときの警告無効化
defaults write com.apple.LaunchServices LSQuarantine -bool false
## ゴミ箱を空にするときの警告無効化
defaults write com.apple.finder WarnOnEmptyTrash -bool "false"

# Default List-View
## icon-view: icnv
## column-view: clmv
## Cover-Flow-View: Flwv
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

killall Finder # enable Finder setting changes
