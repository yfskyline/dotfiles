#!/bin/bash
# Dock: 自動的に隠す
defaults write com.apple.dock autohide -bool true

# MissionControl
# 最近の使用率に応じて並べ替える
defaults write com.apple.dock mru-spaces -bool true

# アプリケーションごとにウィンドウをまとめる
defaults write com.apple.dock expose-group-apps -bool true

# HotCorner
defaults write com.apple.dock wvous-tl-corner -int 13 # 画面をロック
defaults write com.apple.dock wvous-tl-modifier -int 0

# Dock icon size
defaults write com.apple.dock tilesize -int 39

# Automatically hide or show the Dock
defaults write com.apple.dock autohide -bool true

# Wipe all app icons from the Dock exclude Finder and Trash
defaults write com.apple.dock persistent-apps -array

# 設定を反映
killall Dock
