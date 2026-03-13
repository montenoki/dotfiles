#!/bin/sh
# setup-system.sh — deploy files from etc/ to /etc/
# Usage: sudo ./scripts/setup-system.sh [--dry-run|-n]
set -eu

# Resolve dotfiles root (parent of this script's directory)
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
DOTFILES_DIR=$(dirname "$SCRIPT_DIR")

# Must run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: must run as root. Use: sudo $0" >&2
    exit 1
fi

# Parse flags
DRY_RUN=0
for arg in "$@"; do
    case "$arg" in
        --dry-run|-n) DRY_RUN=1 ;;
        *) echo "Unknown option: $arg" >&2; exit 1 ;;
    esac
done

# Check etc/ directory exists
ETC_SRC="$DOTFILES_DIR/etc"
if [ ! -d "$ETC_SRC" ]; then
    echo "No system files to deploy (etc/ not found)."
    exit 0
fi

# Deploy files
find "$ETC_SRC" -type f | while IFS= read -r src; do
    target="/etc${src#"$ETC_SRC"}"
    if [ "$DRY_RUN" -eq 1 ]; then
        echo "[DRY-RUN] would install: $src -> $target"
    else
        install -Dm644 "$src" "$target"
        echo "[COPY] $src -> $target"
    fi
done

if [ "$DRY_RUN" -eq 1 ]; then
    echo "Dry-run complete. No files were modified."
else
    echo "Done. Some changes may require a reboot or service restart to take effect."
fi
