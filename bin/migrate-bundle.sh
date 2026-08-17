#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $(basename "$0") --from <old-bundle-id> --to <new-bundle-id>

Migrates macOS app state from one bundle id to another. Targets the four
standard Library subdirectories the cask zap trash lists:

  ~/Library/Application Support/<old>  ->  ~/Library/Application Support/<new>
  ~/Library/Caches/<old>               ->  ~/Library/Caches/<new>
  ~/Library/Preferences/<old>.plist    ->  ~/Library/Preferences/<new>.plist
  ~/Library/WebKit/<old>               ->  ~/Library/WebKit/<new>

Missing source paths are skipped. The migration is skipped (not overwritten)
when the destination already exists. Pass --dry-run to print what would happen
without moving anything.
EOF
}

from="" to="" dry_run="false"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --from) from="$2"; shift 2 ;;
    --to) to="$2"; shift 2 ;;
    --dry-run) dry_run="true"; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage >&2; exit 1 ;;
  esac
done

[[ -z "$from" || -z "$to" ]] && { echo "Error: --from and --to are required" >&2; usage >&2; exit 1; }
[[ "$from" == "$to" ]] && { echo "Error: --from and --to are identical" >&2; exit 1; }

if [[ "$dry_run" == "true" ]]; then
  echo "[dry-run] Would migrate $from -> $to"
else
  echo "Migrating $from -> $to"
fi

migrate() {
  local src="$1" dst="$2" label="$3"
  if [[ ! -e "$src" ]]; then
    echo "  [skip] $label: source not found ($src)"
  elif [[ -e "$dst" ]]; then
    echo "  [skip] $label: destination already exists ($dst)"
  else
    echo "  [move] $label"
    [[ "$dry_run" == "true" ]] || mv "$src" "$dst"
  fi
}

migrate "$HOME/Library/Application Support/$from" "$HOME/Library/Application Support/$to" "Application Support"
migrate "$HOME/Library/Caches/$from"              "$HOME/Library/Caches/$to"              "Caches"
migrate "$HOME/Library/Preferences/$from.plist"   "$HOME/Library/Preferences/$to.plist"   "Preferences"
migrate "$HOME/Library/WebKit/$from"              "$HOME/Library/WebKit/$to"              "WebKit"

[[ "$dry_run" == "true" ]] && echo "[dry-run] No files moved." || echo "Done."
