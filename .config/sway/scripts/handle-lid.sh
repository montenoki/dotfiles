#!/bin/sh

# 自动获取笔记本内建屏幕名称（通常是 eDP-1/eDP-2/...）
LAPTOP_OUTPUT=$(swaymsg -t get_outputs | grep -o '"eDP[^"]*"' | tr -d '"')

# 如果没找到 eDP 屏幕，直接退出
if [ -z "$LAPTOP_OUTPUT" ]; then
    echo "No eDP laptop output detected." >&2
    exit 1
fi

# 读取盖子状态
LID_STATE_FILE="/proc/acpi/button/lid/LID/state"
read -r LS <"$LID_STATE_FILE"

# 判断是否存在"非笔记本输出"
has_external() {
    swaymsg -t get_outputs | grep -oP '"name":\s*"\K[^"]+' | grep -qv "^${LAPTOP_OUTPUT}$"
}

case "$LS" in
*open)
    swaymsg output "$LAPTOP_OUTPUT" enable
    ;;
*closed)
    if has_external; then
        # 有外接屏：只关闭主屏
        swaymsg output "$LAPTOP_OUTPUT" disable
    else
        # 没外接屏：锁屏，然后关闭主屏
        swaylock -f -c 000000
        swaymsg output "$LAPTOP_OUTPUT" disable
    fi
    ;;
*)
    echo "Could not get lid state" >&2
    exit 1
    ;;
esac
