#!/usr/bin/env bash
defaults write com.apple.Music checkForAvailableDownloads -bool true
defaults write com.apple.Music losslessEnabled -bool true
defaults write com.apple.Music preferredDolbyAtmosPlaySetting -int 30
defaults write com.apple.Music multichannelAudioStrategy -bool true
defaults write com.apple.Music optimizeSongVolume -bool false

# SoundEnhancer
defaults write com.apple.Music soundEnhancerAmount 200
defaults write com.apple.Music soundEnhancerEnabled 1
