#!/usr/bin/env bash
set -e

# ===== 参数 =====
MODE="$1"
SCREENSHOT_DIR="$2"

if [[ -z "$MODE" || -z "$SCREENSHOT_DIR" ]]; then
    echo "Usage: $0 {full|select} <screenshot_dir>"
    exit 1
fi

TIMESTAMP="$(date +'%Y-%m-%d_%H-%M-%S')"
FILE="$SCREENSHOT_DIR/screenshot_${MODE}_$TIMESTAMP.png"
mkdir -p "$SCREENSHOT_DIR"

# ===== 截图 =====
case "$MODE" in
full)
    grim "$FILE"
    ;;
select)
    REGION=$(slurp) || exit 0
    grim -g "$REGION" "$FILE"
    ;;
*)
    exit 1
    ;;
esac

# ===== 复制到剪贴板 + 通知 =====
if [[ -f "$FILE" ]]; then
    wl-copy <"$FILE"
    notify-send -i "$FILE" "📸 截图完成" "$(basename "$FILE")"
fi
