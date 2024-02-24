# Run ssh-agent
proc_name=ssh-agent
proc_count=`ps aux | grep $proc_name | grep -v grep | wc -l`
if [[ $proc_count -le 1 ]];then
  eval $(`which $proc_name`)
else
  echo $proc_name is running..
fi
# Add private key
for key in ~/.ssh/id_ed25519; do
	if ! ssh-add -l | grep -q "$(ssh-keygen -lf "$key" | cut -d \  -f 2)"; then
		ssh-add "$key"
  else
    echo $key is exist.
	fi
done

# Auto run neofetch
if [[ -x `which neofetch` ]] &&
  [[ -z $VIMRUNTIME ]]; then # Not in Vim
  eval "neofetch"
fi
