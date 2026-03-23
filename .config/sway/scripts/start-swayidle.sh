#!/bin/sh
# 启动 swayidle 节电守护进程
# 先杀掉旧实例，再启动新实例（确保串行执行，避免 sway exec_always 并发竞争）

pkill -x swayidle 2>/dev/null

# 超时时间（秒）—— 插电时 x3
T_LOCK=300       # 5 分钟后锁屏
T_DPMS_OFF=600   # 10 分钟后关屏
T_SUSPEND=1800   # 30 分钟后挂起

# 检测是否插电（AC online = 1）
AC_ONLINE=$(cat /sys/class/power_supply/AC/online 2>/dev/null || echo 0)
if [ "$AC_ONLINE" = "1" ]; then
    T_LOCK=$((T_LOCK * 3))
    T_DPMS_OFF=$((T_DPMS_OFF * 3))
    T_SUSPEND=$((T_SUSPEND * 3))
fi

exec swayidle -w \
    timeout $T_LOCK      'swaylock -f -c 000000' \
    timeout $T_DPMS_OFF  'swaymsg "output * dpms off"' \
    resume               'swaymsg "output * dpms on"' \
    timeout $T_SUSPEND   'systemctl suspend' \
    before-sleep         'swaylock -f -c 000000'
