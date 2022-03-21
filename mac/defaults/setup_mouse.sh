#!/usr/bin/env bash
# mouse

# タップしたときに、クリックとする
defaults write -g com.apple.mouse.tapBehavior -int 1
# マウスの速度を速める
defaults write -g com.apple.mouse.scaling 3
# 3本指でmission control & expose
# defaults write com.apple.dock showMissionControlGestureEnabled -bool true
defaults write com.apple.dock showAppExposeGestureEnabled -bool true
# defaults write com.apple.dock showDesktopGestureEnabled -bool true
# defaults write com.apple.dock showLaunchpadGestureEnabled -bool true
