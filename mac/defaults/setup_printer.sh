#!/usr/bin/env bash
# Printer and Scanner

# Automatically quit the printer app once the print jobs are completed
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
