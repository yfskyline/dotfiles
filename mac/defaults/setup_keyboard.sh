#!/bin/bash
## Only parameters different from default

# KeyBoard (設定の反映はログアウトが必要)
## 1 * 15ms = 15ms
defaults write -g KeyRepeat -int 1
# defaults write -g KeyRepeat -int 2 # システム上限

## 10 * 15ms = 150ms
defaults write -g InitialKeyRepeat -int 10
# defaults write -g InitialKeyRepeat -int 15 # システム上限

# CapsLock を Ctrl に変更する
# get string like : 1452-630-0 for keyboard_id (ref: http://freewing.starfree.jp/software/macos_keyboard_setting_terminal_commandline)
keyboard_id="$(ioreg -c AppleEmbeddedKeyboard -r | grep -Eiw "VendorID|ProductID" | awk '{ print $4 }' | paste -s -d'-\n' -)-0"
defaults -currentHost write -g com.apple.keyboard.modifiermapping.${keyboard_id} -array-add "
<dict>
  <key>HIDKeyboardModifierMappingDst</key>\
  <integer>30064771300</integer>\
  <key>HIDKeyboardModifierMappingSrc</key>\
  <integer>30064771129</integer>\
</dict>
"

# User Dictionary
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g WebAutomaticSpellingCorrectionEnabled -bool false

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
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 82 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>59</integer><integer>41</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"
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
## Japanese(Roma-ji)
### Correct Type-Mis
defaults write com.apple.inputmethod.Kotoeri JIMPrefAutocorrectionKey -bool false

### display recommendation
defaults write com.apple.inputmethod.Kotoeri JIMPrefPredictiveCandidateKey -bool false

### PunctuationType(. and ,)
defaults write com.apple.inputmethod.Kotoeri JIMPrefPunctuationTypeKey -int 3

### Yen-Key
defaults write com.apple.inputmethod.Kotoeri JIMPrefCharacterForYenKey -int 1

# Voice Input
## ShortCut
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 164 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>65535</integer><integer>0</integer></array><key>type</key><string>standard</string></dict></dict>"

