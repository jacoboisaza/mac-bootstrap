#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

bash -n \
  "$ROOT_DIR/setup" \
  "$ROOT_DIR/stage0" \
  "$ROOT_DIR/doctor" \
  "$ROOT_DIR/update" \
  "$ROOT_DIR/snapshot" \
  "$ROOT_DIR"/config/*.sh \
  "$ROOT_DIR"/scripts/*.sh

if command -v node >/dev/null 2>&1; then
  node -e 'JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"))' \
    "$ROOT_DIR/config/vscode-settings.json"
fi

if command -v ruby >/dev/null 2>&1; then
  ruby -c "$ROOT_DIR/Brewfile" >/dev/null
  for manifest in "$ROOT_DIR"/brew/Brewfile.*; do ruby -c "$manifest" >/dev/null; done
fi

if [[ -d "$ROOT_DIR/.git" ]]; then
  git -C "$ROOT_DIR" diff --check
  # Agent permission rules block .env files, so version pins live in config/*.sh.
  if [[ -n "$(git -C "$ROOT_DIR" ls-files 'config/*.env')" ]]; then
    echo "Tracked config/*.env files: move their values to config/*.sh" >&2
    exit 1
  fi
fi

output="$(PATH="$ROOT_DIR/tests/stubs:$PATH" "$ROOT_DIR/setup" --dry-run)"
for expected in \
  "install Homebrew" \
  "Required Homebrew tools" \
  "Desktop applications" \
  "Claude Code" \
  "VS Code extensions" \
  "Oh My Zsh" \
  "Node.js" \
  "Python" \
  "graphify" \
  "macos-defaults.sh" \
  "doctor"
do
  [[ "$output" == *"$expected"* ]] || {
    echo "Dry-run output missing: $expected" >&2
    exit 1
  }
done

echo "Smoke tests passed."
