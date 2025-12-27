#!/usr/bin/env bash
set -e

# ===== 参数 =====
MODE="$1"           # full / select
SCREENSHOT_DIR="$2" # 从 sway 传入

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
    grim -g "$(slurp)" "$FILE" || exit 0
    ;;
*)
    exit 1
    ;;
esac

# ===== 通知 =====
[[ -f "$FILE" ]] && notify-send -i "$FILE" "📸 截图完成" "$(basename "$FILE")"
