#!/usr/bin/env bash

set -euo pipefail

APP="com.microsoft.Outlook"

# Keyboard shortcut preset
# 0: Outlook
# 1: Apple Mail
# 2: Gmail
defaults write "$APP" \
	UserPreference_KeyboardShortcutsPreset -int 1

# Custom keyboard shortcuts (Japanese / English)
defaults write "$APP" NSUserKeyEquivalents -dict \
	"未読"        '@l'      \
	"Unread"      '@l'      \
	"アーカイブ"  $'^\x08' \
	"Archive"     $'^\x08' \
	"削除"        $'\x08'  \
	"Delete"      $'\x08'  \
	"全員に返信"  '@r'      \
	"Reply All"   '@r'      \
	"返信"        "@\$r"    \
	"Reply"       "@\$r"
