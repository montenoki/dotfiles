# 如果关闭最后一个终端，则结束ssh-agent进程

# 根据操作系统类型选择不同的tty计数方式
if [[ "$OSTYPE" == "darwin"* ]]; then
  # MacOS系统：统计当前用户其他终端数量
  other_tty_count=$(ps aux | grep `whoami` | awk '{print $7}' | grep -v `tty | sed -E 's:/dev/tty::'` | grep -v \? | wc -l)  
else
  # Linux系统：统计当前用户其他终端数量
  other_tty_count=$(ps aux | grep `whoami` | awk '{print $7}' | grep -v `tty | sed -E 's:/dev/::'` | grep -v \? | wc -l)
fi

# 如果没有其他终端在运行
if [[ $other_tty_count -le 0 ]]; then
echo Cleanup:
  # 显示将要终止的ssh-agent进程
  ps aux | grep "ssh-agent" | grep -v grep | awk '{print "kill -9 " $2}'
  # 终止所有ssh-agent进程
  ps aux | grep "ssh-agent" | grep -v grep | awk '{print "kill -9 " $2}' | zsh
  # 等待1秒确保进程被终止
  sleep 1
fi
