ps -axf | grep ssh-agent | grep -v grep | awk '{print "kill -9 " $1}' | zsh
