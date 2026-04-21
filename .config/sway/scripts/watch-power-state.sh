#!/bin/sh
# 监听 AC 插拔事件，触发时重启 swayidle 以刷新超时配置
# 先杀掉旧实例，再启动新的监听进程

pkill -f "udevadm monitor --subsystem-match=power_supply" 2>/dev/null

udevadm monitor --subsystem-match=power_supply --property | while read -r line; do
    if [ "$line" = "POWER_SUPPLY_NAME=AC" ]; then
        ~/.config/sway/scripts/start-swayidle.sh
    fi
done
