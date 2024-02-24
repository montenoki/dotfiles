# Add ssh-key
proc_name=ssh-agent
proc_count=`ps -ef |grep -w $proc_name|grep -v grep|wc -l`
if [ $proc_count -le 0 ];then
  eval `ssh-agent`
else
➜ ps aux | grep ssh-agent | grep -v grep | awk '{print "kill -9 " $2}' | zsh
  eval `ssh-agent`
fi
for key in ~/.ssh/id_ed25519; do
	if ! ssh-add -l | grep -q "$(ssh-keygen -lf "$key" | cut -d \  -f 2)"; then
		ssh-add "$key"
  else
    echo $key is exist.
	fi
done

# Auto run neofetch
if [[ -x `which neofetch` ]]; then
  eval "neofetch"
fi
