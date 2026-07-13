#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DRY_RUN="${DRY_RUN:-0}"

log() { printf '\n==> %s\n' "$*"; }
warn() { printf 'WARNING: %s\n' "$*" >&2; }
run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '+ '
    printf '%q ' "$@"
    printf '\n'
  else
    "$@"
  fi
}

backup_and_link() {
  local source="$1" target="$2" backup_root="$3"
  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    return 0
  fi
  if [[ "$DRY_RUN" == "1" ]]; then
    [[ -e "$target" || -L "$target" ]] && printf '+ backup %q to %q\n' "$target" "$backup_root"
    printf '+ link %q to %q\n' "$target" "$source"
    return 0
  fi
  mkdir -p "$(dirname "$target")"
  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$backup_root"
    run mv "$target" "$backup_root/$(basename "$target")"
  fi
  run ln -s "$source" "$target"
}
