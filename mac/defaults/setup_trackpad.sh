#!/bin/bash
defaults write -g "com.apple.trackpad.forceClick" -bool true

# Enable 'Tap to Click'
defaults write com.apple.driver.AppleMultitouch.trackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# クリック
defaults write com.apple.driver.AppleMultitouch.trackpad FirstClickThreshold -int 2
defaults write com.apple.driver.AppleMultitouch.trackpad SecondClickThreshold -int 2

# 軌跡
defaults write -g com.apple.trackpad.scaling -int 3

# Scroll Direction: Natural
defaults write -g com.apple.swipescrolldirection -bool true


# Other Gesture
defaults write com.apple.dock showAppExposeGestureEnabled -bool true
