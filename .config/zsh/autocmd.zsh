# Run ssh-agent
proc_name=ssh-agent
proc_count=`ps aux | grep $proc_name | grep -v grep | wc -l`
if [[ $proc_count -le 20 ]];then
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

# Auto source venv for python
function cd() {
  builtin cd "$@"

  if [[ -z "$VIRTUAL_ENV" ]] ; then
    ## If env folder is found then activate the vitualenv
      if [[ -d ./.venv ]] ; then
        source ./.venv/bin/activate
      fi
  else
    ## check the current folder belong to earlier VIRTUAL_ENV folder
    # if yes then do nothing
    # else deactivate
      parentdir="$(dirname "$VIRTUAL_ENV")"
      if [[ "$PWD"/ != "$parentdir"/* ]] ; then
        deactivate
      fi
  fi
}
