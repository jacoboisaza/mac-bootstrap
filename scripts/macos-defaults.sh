#!/bin/bash
set -euo pipefail

# Conservative developer defaults. Run only through setup or explicitly.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
mkdir -p "$HOME/Pictures/Screenshots"

killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true
