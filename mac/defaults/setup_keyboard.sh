#!/bin/bash
## Only parameters different from default

# KeyBoard (設定の反映はログアウトが必要)
defaults write -g KeyRepeat -int 1
# defaults write -g KeyRepeat -int 2 # システム上限
defaults write -g InitialKeyRepeat -int 10
# defaults write -g InitialKeyRepeat -int 15 # システム上限


# User Dictionary

# Shortcuts
## Dock automatically on/off
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 52 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>122</integer><integer>9961472</integer></array><key>type</key><string>standard</string></dict></dict>"

## Mission Control: CTRL+Enter
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 32 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>36</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 34 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>36</integer><integer>393216</integer></array><key>type</key><string>standard</string></dict></dict>"

## Disable Application Window
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 33 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>125</integer><integer>8650752</integer></array><key>type</key><string>standard</string></dict></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 35 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>36</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"

## Mission Control: Move left
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>59</integer><integer>41</integer><integer>393216</integer></array><key>type</key><string>standard</string></dict></dict>"

## Mission Control: Move right
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 82 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>59</integer><integer>41</integer><integer>393216</integer></array><key>type</key><string>standard</string></dict></dict>"

## Use NextWindow
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 27 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>48</integer><integer>524288</integer></array><key>type</key><string>standard</string></dict></dict>"

## Forehand Input Source
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>48</integer><integer>524288</integer></array><key>type</key><string>standard</string></dict></dict>"

## Next Input Source
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>48</integer><integer>524288</integer></array><key>type</key><string>standard</string></dict></dict>"

## Spotlight
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>49</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"

## Finder search window
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>49</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"

## Voice Over on/off
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 59 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>49</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"

## display Accessibility Control
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 162 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>49</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"

## display Help
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 98 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>49</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"


# Input Source

# Voice Input
