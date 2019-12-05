/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
defaults write com.google.drivefs.settings BandwidthRxKBPS -int 1000
defaults write com.google.drivefs.settings BandwidthTxKBPS -int 1000
