#!/bin/sh

# 定义用户级配置文件路径
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
# 定义系统级配置文件路径
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# 加载默认配置和按键映射

# 加载系统级资源配置
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

# 加载系统级按键映射
if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

# 加载用户级资源配置
if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

# 加载用户级按键映射
if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# 启动其他程序
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
        # shellcheck source=/dev/null
        [ -x "$f" ] && . "$f" # 执行所有可执行的启动脚本
    done
    unset f
fi

# 启动i3窗口管理器
exec i3
