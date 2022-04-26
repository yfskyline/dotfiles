#!/usr/bin/env bash
# terminal

# Use a custom theme
# Use the 'skyline' theme by default in Terminal.app
TERM_PROFILE='skyline';
TERM_PATH='../';
CURRENT_PROFILE="$(defaults read com.apple.terminal 'Default Window Settings')";
if [ "${CURRENT_PROFILE}" != "${TERM_PROFILE}" ]; then
    open "$TERM_PATH$TERM_PROFILE.terminal"
    defaults write com.apple.Terminal "Default Window Settings" -string "$TERM_PROFILE"
    defaults write com.apple.Terminal "Startup Window Settings" -string "$TERM_PROFILE"
fi
defaults import com.apple.Terminal "$HOME/Library/Preferences/com.apple.Terminal.plist"


# ターミナルの文字エンコーディング指定を UTF-8だけにする
# defaults write com.apple.terminal StringEncodings -array 4

defaults write com.apple.terminal "Default Window Settings" -string "skyline"
