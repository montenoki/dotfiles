# Add ssh-key
proc_name=ssh-agent
proc_count=`ps -ef |grep -w $proc_name|grep -v grep|wc -l`
if [ $proc_count -le 0 ];then
  eval `ssh-agent`
else
   echo $proc_name is  running..
fi
for key in ~/.ssh/id_ed25519; do
	if ! ssh-add -l | grep -q "$(ssh-keygen -lf "$key" | cut -d \  -f 2)"; then
		ssh-add "$key"
  else
    echo $key is exist.
	fi
done

# Use Tmux automatically base on term program
session="work"
if [ "$TERM" = 'alacritty' ] ||
  [ "$TERM_PROGRAM" = 'WezTerm' ]; then
  tmux has -t $session &> /dev/null
  if [ $? != 0 ]; then
    tmux new -s $session
  elif [ -z $TMUX ]; then
    tmux attach -t $session
  fi
fi
