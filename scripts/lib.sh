#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DRY_RUN="${DRY_RUN:-0}"

log() { printf '\n[%s] ==> %s\n' "$(date '+%H:%M:%S')" "$*"; }
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

# Run a foreground command normally so prompts still work, while a background
# heartbeat confirms that the bootstrap has not stalled during quiet periods.
run_progress() {
  local label="$1"
  shift
  local started_at=$SECONDS heartbeat_pid status elapsed

  log "$label"
  if [[ "$DRY_RUN" == "1" ]]; then
    run "$@"
    return 0
  fi

  (
    while true; do
      sleep 20
      printf '... %s still running (%dm %02ds elapsed)\n' \
        "$label" "$(((SECONDS - started_at) / 60))" "$(((SECONDS - started_at) % 60))"
    done
  ) &
  heartbeat_pid=$!

  trap 'kill "$heartbeat_pid" 2>/dev/null || true; exit 130' INT TERM

  set +e
  "$@"
  status=$?
  set -e

  kill "$heartbeat_pid" 2>/dev/null || true
  wait "$heartbeat_pid" 2>/dev/null || true
  trap - INT TERM
  elapsed=$((SECONDS - started_at))

  if [[ "$status" -eq 0 ]]; then
    printf 'DONE  %s (%dm %02ds)\n' "$label" "$((elapsed / 60))" "$((elapsed % 60))"
  else
    printf 'FAILED %s after %dm %02ds (exit %d)\n' \
      "$label" "$((elapsed / 60))" "$((elapsed % 60))" "$status" >&2
  fi
  return "$status"
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
