#!/bin/bash
set -euo pipefail

command -v gh >/dev/null || { echo "Install GitHub CLI first." >&2; exit 1; }
key="$HOME/.ssh/id_ed25519_github_$(scutil --get LocalHostName 2>/dev/null || hostname -s)"
if [[ -e "$key" ]]; then
  echo "Key already exists: $key"
  exit 0
fi
read -r -p "GitHub email for the key comment: " email
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
ssh-keygen -t ed25519 -a 100 -C "$email" -f "$key"
echo "Authenticate if needed, then upload the public key:"
echo "  gh auth login"
echo "  gh ssh-key add ${key}.pub --title $(hostname -s)"
