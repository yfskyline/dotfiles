#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for script in \
    setup_dock.sh \
    setup_finder.sh \
    setup_trackpad.sh \
    setup_keyboard.sh \
    setup_spotlight.sh \
    setup_ical.sh \
    setup_mouse.sh \
    setup_safari.sh \
    setup_maps.sh \
    setup_printer.sh \
    setup_terminal.sh \
    setup_currentHost.sh \
    setup_general.sh \
    setup_hammerspoon.sh \
    setup_music.sh \
    setup_display.sh \
    setup_windowmanager.sh \
    setup_others.sh
do
    echo "[RUN] $script"
    bash "$SCRIPT_DIR/$script"
done
