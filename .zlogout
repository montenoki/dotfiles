# If close the last tty then kill ssh-agent
other_tty_count=`ps aux -o tty | grep tty | grep -v `tty | sed -E 's:/dev/jj::'` | grep -v grep | wc -l`
if [[ $other_tty_count -le 0 ]]; then
  ps aux | grep "ssh-agent" | grep -v grep | awk '{print "kill -9 " $2}' | zsh
fi
