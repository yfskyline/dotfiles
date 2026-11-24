#!/usr/bin/env bash

set -euo pipefail

APP="com.apple.mail"

# Custom keyboard shortcuts (Japanese / English)
defaults write "$APP" NSUserKeyEquivalents -dict \
	"アーカイブ"  $'^\x08' \
	"Archive"     $'^\x08' \
	"全員に返信"  '@r'     \
	"Reply All"   '@r'     \
	"返信"        "@\$r"   \
	"Reply"       "@\$r"
