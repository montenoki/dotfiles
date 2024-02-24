# If close the last tty then kill ssh-agent
if [[ "$OSTYPE" == "darwin"* ]]; then
  other_tty_count=$(ps aux | grep `whoami` | awk '{print $7}' | grep -v `tty | sed -E 's:/dev/tty::'` | grep -v \? | wc -l)  
else
  other_tty_count=$(ps aux | grep `whoami` | awk '{print $7}' | grep -v `tty | sed -E 's:/dev/::'` | grep -v \? | wc -l)
fi
if [[ $other_tty_count -le 0 ]]; then
  ps aux | grep "ssh-agent" | grep -v grep | awk '{print "kill -9 " $2}' | zsh
fi
