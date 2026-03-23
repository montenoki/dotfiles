#!/bin/bash
THRESHOLD_FILE="/sys/class/power_supply/BAT0/charge_control_end_threshold"
THRESHOLD=$(cat "$THRESHOLD_FILE" 2>/dev/null || echo "100")

if [ "$1" = "toggle" ]; then
    if [ "$THRESHOLD" -ge 100 ]; then
        NEW=85
        MSG="健康模式 (上限 85%)"
    else
        NEW=100
        MSG="长续航模式 (上限 100%)"
    fi

    if echo "$NEW" | sudo tee "$THRESHOLD_FILE" > /dev/null 2>&1; then
        notify-send -i battery "电池充电上限" "$MSG"
    else
        notify-send -u critical -i battery "电池充电上限" "写入失败，请检查 sudoers 规则"
    fi

    pkill -SIGRTMIN+8 waybar
    exit 0
fi

if [ "$THRESHOLD" -ge 100 ]; then
    printf '{"alt": "full", "tooltip": "长续航模式 (上限 100%%)\\n点击切换为健康模式", "class": "full"}\n'
else
    printf '{"alt": "health", "tooltip": "健康模式 (上限 85%%)\\n点击切换为长续航模式", "class": "health"}\n'
fi
