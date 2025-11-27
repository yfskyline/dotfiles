#!/usr/bin/env bash
# Spotlight Settings for macOS Sequoia & Tahoe
# Purpose: Enable only Launcher (Apps) and Calculator functions.
# Disable everything else to reduce indexing load.

# Get OS version
OS_VER=$(sw_vers -productVersion)
MAJOR_VER=$(echo "$OS_VER" | cut -d '.' -f 1)
echo "Detected macOS version: $OS_VER (Major: $MAJOR_VER)"

# Stop Spotlight indexing
echo "Stopping Spotlight services..."
killall mds > /dev/null 2>&1
mdutil -i off / > /dev/null

echo "Configuring Spotlight preferences..."
# display 'developer'
if [ ! -e /Applications/Xcode.app ]; then
	sudo touch /Applications/Xcode.app
fi

# Change indexing order and siable some search results
defaults write com.apple.spotlight orderedItems -array \
    '{"enabled" = 1; "name" = "APPLICATIONS";}' \
    '{"enabled" = 1; "name" = "MENU_EXPRESSION";}' \
    '{"enabled" = 1; "name" = "MENU_CONVERSION";}' \
    '{"enabled" = 0; "name" = "MENU_SPOTLIGHT_SUGGESTIONS";}' \
    '{"enabled" = 0; "name" = "MENU_DEFINITION";}' \
    '{"enabled" = 0; "name" = "SYSTEM_PREFS";}' \
    '{"enabled" = 0; "name" = "DOCUMENTS";}' \
    '{"enabled" = 0; "name" = "DIRECTORIES";}' \
    '{"enabled" = 0; "name" = "PRESENTATIONS";}' \
    '{"enabled" = 0; "name" = "SPREADSHEETS";}' \
    '{"enabled" = 0; "name" = "PDF";}' \
    '{"enabled" = 0; "name" = "MESSAGES";}' \
    '{"enabled" = 0; "name" = "CONTACT";}' \
    '{"enabled" = 0; "name" = "EVENT_TODO";}' \
    '{"enabled" = 0; "name" = "IMAGES";}' \
    '{"enabled" = 0; "name" = "BOOKMARKS";}' \
    '{"enabled" = 0; "name" = "MUSIC";}' \
    '{"enabled" = 0; "name" = "MOVIES";}' \
    '{"enabled" = 0; "name" = "FONTS";}' \
    '{"enabled" = 0; "name" = "MENU_OTHER";}' \
    '{"enabled" = 0; "name" = "SOURCE";}'

killall cfprefsd

# Load new settings before rebuilding the index
echo "Restarting Spotlight services (Root privileges required)..."
sudo killall mds > /dev/null 2>&1
sudo mdutil -i off / > /dev/null

# Rebuild the index from scratch
sudo mdutil -E / > /dev/null

# Make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null

# remove blank xcode.app
# rm /Applications/Xcode.app

echo "Spotlight configuration complete."
echo "Please allow a few minutes for Spotlight to re-index with the new settings."
echo "Settings appliet to current user, and System Index rebuilt."
