#!/usr/bin/env bash
# Setup Raycast Settings for macOS Sequoia & Tahoe
open ~/skyline/dotfiles/mac/raycast/skyline.rayconfig

# Disable Spotlight GUI shortcut and Optimize Index for Raycast
echo "Detected macOS Version: $(sw_vers -productVersion)"

echo "Disabling Spotlight keyboard shortcut..."
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null

if [ $? -ne 0 ]; then
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 \
    '<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>'
fi

killall SystemUIServer

echo "Configuring Spotlight scope for Raycast (Apps only)..."

defaults write com.apple.spotlight orderedItems -array \
    '{"enabled" = 1; "name" = "APPLICATIONS";}' \
    '{"enabled" = 0; "name" = "MENU_EXPRESSION";}' \
    '{"enabled" = 0; "name" = "MENU_CONVERSION";}' \
    '{"enabled" = 0; "name" = "MENU_SPOTLIGHT_SUGGESTIONS";}' \
    '{"enabled" = 0; "name" = "SYSTEM_PREFS";}' \
    '{"enabled" = 0; "name" = "DIRECTORIES";}' \
    '{"enabled" = 0; "name" = "PDF";}' \
    '{"enabled" = 0; "name" = "FONTS";}' \
    '{"enabled" = 0; "name" = "DOCUMENTS";}' \
    '{"enabled" = 0; "name" = "MESSAGES";}' \
    '{"enabled" = 0; "name" = "CONTACT";}' \
    '{"enabled" = 0; "name" = "EVENT_TODO";}' \
    '{"enabled" = 0; "name" = "IMAGES";}' \
    '{"enabled" = 0; "name" = "BOOKMARKS";}' \
    '{"enabled" = 0; "name" = "MUSIC";}' \
    '{"enabled" = 0; "name" = "MOVIES";}' \
    '{"enabled" = 0; "name" = "PRESENTATIONS";}' \
    '{"enabled" = 0; "name" = "SPREADSHEETS";}' \
    '{"enabled" = 0; "name" = "SOURCE";}' \
    '{"enabled" = 0; "name" = "MENU_DEFINITION";}' \
    '{"enabled" = 0; "name" = "MENU_OTHER";}'

killall cfprefsd

echo "Restarting Spotlight services to apply changes..."
echo "Note: You might be asked for your password."

sudo killall mds > /dev/null 2>&1

sudo mdutil -E / > /dev/null
sudo mdutil -i on / > /dev/null

echo "Done. Spotlight shortcut (Cmd+Space) is disabled."
echo "Indexing is optimized for Raycast (Apps only)."
