#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

bash -n \
  "$ROOT_DIR/setup" \
  "$ROOT_DIR/stage0" \
  "$ROOT_DIR/doctor" \
  "$ROOT_DIR/update" \
  "$ROOT_DIR/snapshot" \
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
fi

output="$(PATH="$ROOT_DIR/tests/stubs:$PATH" "$ROOT_DIR/setup" --dry-run)"
for expected in \
  "install Homebrew" \
  "Required Homebrew tools" \
  "Desktop applications" \
  "VS Code extensions" \
  "Oh My Zsh" \
  "Node.js" \
  "Python" \
  "macos-defaults.sh" \
  "doctor"
do
  [[ "$output" == *"$expected"* ]] || {
    echo "Dry-run output missing: $expected" >&2
    exit 1
  }
done

echo "Smoke tests passed."
