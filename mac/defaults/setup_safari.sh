#!/usr/bin/env bash
# Safari

# Enable the `Develop` menu and the `Web Inspector`
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true

# Enable `Debug` menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Show the full URL in the address bar (note: this will still hide the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Add a context menu item for showing the `Web Inspector` in web views
# defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Show Safari's Status Bar （ステータスバーを表示）
defaults write com.apple.Safari ShowStatusBar -bool true

# Don't remember passwords （パスワードを自動入力・記録しない）
defaults write com.apple.Safari AutoFillPasswords -bool false
