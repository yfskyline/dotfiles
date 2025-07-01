#!/usr/bin/env bash
# Dock icon size
defaults write com.apple.dock tilesize -int 40

# Magnification of Dock icon
defaults write com.apple.dock magnification -bool false

# Dock Position
defaults write com.apple.dock orientation -string bottom

# ウィンドウをしまうときのエフェクト
defaults write com.apple.dock mineffect -string genie

# Window DoubleClick Action
defaults write com.apple.dock AppleActionOnDoubleClick -string Minimize

# Minimize to Application
defaults write com.apple.dock minimize-to-application -bool false

# Animation when 
defaults write com.apple.dock launchanim -bool true

# Automatically hide or show the Dock
defaults write com.apple.dock autohide -bool true

# 起動ずみアプリケーションにインジケータを表示
defaults write com.apple.dock show-process-indicators -bool false

# 最近使ったアプリケーションをDockに表示
defaults write com.apple.dock show-recents -bool false


# MenuBar
# Desktopにメニュー場を自動的に表示/非常時
defaults write -g _HIHideMenuBar -bool false
# フルスクリーンでメニューバーを自動的に表示/非表示
defaults write -g AppleMenuBarVisibleInFullscreen -bool false

# Control Center
defaults write com.apple.controlcenter "NSStatusItem Visible WiFi" -bool true
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true
defaults write com.apple.controlcenter "NSStatusItem Visible AirDrop" -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible FocusModes" -bool true
defaults write com.apple.controlcenter "NSStatusItem Visible KeyboardBrightness" -bool false
defaults write com.apple.airplay "NSStatusItem Visible showInMenuBarIfPresent" -bool true
defaults write com.apple.controlcenter "NSStatusItem Visible Display" -bool true
defaults write com.apple.controlcenter "NSStatusItem Visible NowPlaying" -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool true
defaults write com.apple.controlcenter "NSStatusItem Visible AccessibilityShortcuts" -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible Battery" -bool false
defaults write com.apple.menuextra.battery "ShowPercent" -string YES
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true

defaults write com.apple.menuextra.clock "IsAnalog" -bool false
defaults write com.apple.menuextra.clock "ShowDayOfMonth" -bool true
defaults write com.apple.menuextra.clock "ShowDayOfWeek" -bool true
defaults write com.apple.menuextra.clock "ShowSeconds" -bool true
defaults write com.apple.menuextra.clock "FlashDateSeparators" -bool false
defaults write com.apple.menuextra.clock "DateFormat" -string "M\u6708d\u65e5(EEE) K:mm:ss"

# Spotlight in menubar
defaults write com.apple.Spotlight "NSStatusItem Visible Item-0" -bool true
defaults write com.apple.systemuiserver "NSStatusItem Visible Siri" -bool false
defaults write com.apple.Siri "StatusMenuVisible" -bool false
defaults write com.apple.Siri "VoiceTriggerUserEnabled" -bool false

defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.TimeMachine" -bool false

defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.airport" -bool false
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.airplay" -bool false
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.battery" -bool true
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.bluetooth" -bool true
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.clock" -bool true
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.volume" -bool true
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.vpn" -bool true
defaults write com.apple.systemuiserver "menuExtras" -array "/System/Library/CoreServices/Menu Extras/VPN.menu"

# MissionControl
# 最近の使用率に応じて並べ替える
# defaults write com.apple.dock mru-spaces -bool true

# アプリケーションごとにウィンドウをまとめる
defaults write com.apple.dock expose-group-apps -bool true

# HotCorner
## Possible values:
## 0: no-op
## 2: Mission Control
## 3: Show application windows
## 4: Desktop
## 5: Start Screen Saver
## 6: Disable Screen Saver
## 7: Dashboard
## 10: Put display to sleep
## 11: Launchpad
## 12: Notification Center
# Top left
# defaults write com.apple.dock wvous-tl-corner -int 13 # 画面をロック
# defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right
# defaults write com.apple.dock wvous-tr-corner -int 13 # 画面をロック
# defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left
# defaults write com.apple.dock wvous-bl-corner -int 13 # 画面をロック
# defaults write com.apple.dock wvous-bl-modifier -int 0
# Bottom right
# defaults write com.apple.dock wvous-br-corner -int 13 # 画面をロック
# defaults write com.apple.dock wvous-br-modifier -int 0


# Wipe all app icons from the Dock exclude Finder and Trash
defaults write com.apple.dock persistent-apps -array

# apply the settings
killall Dock
