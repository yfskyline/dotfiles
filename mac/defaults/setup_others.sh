# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Save screenshots as PNGs （スクリーンショット保存形式をPNGにする）
# defaults write com.apple.screencapture type -string "png"

# Require password immediately after the computer went into
# sleep or screen saver mode （スリープまたはスクリーンセーバから復帰した際、パスワードをすぐに要求する）
# defaults write com.apple.screensaver askForPassword -int 1
# defaults write com.apple.screensaver askForPasswordDelay -int 0


# Feedback
## disable 'crash report'
defaults write com.apple.CrashReporter DialogType -string "none"
## disable sending 'feedback'
defaults write com.apple.appleseed.FeedbackAssistant "Autogather" -bool "false"


## 未確認のアプリケーションを実行する際のダイアログを無効にする


# .DS_Store
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool "true"
