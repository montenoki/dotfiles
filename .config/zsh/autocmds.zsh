#!/usr/bin/env bash

# Run ssh-agent
proc_name=ssh-agent
proc_count=$(pgrep -f $proc_name | grep -v grep -c)
agent="$(which $proc_name)"
if [[ $proc_count -le 20 ]]; then
	eval "$($agent)"
else
	echo $proc_name is running..
fi

# Add private key
typeset -ga keys
keys+=("$HOME/.ssh/id_ed25519")
for key in "${keys[@]}"; do
	if ! ssh-add -l | grep -q "$(ssh-keygen -lf "$key" | cut -d \  -f 2)"; then
		ssh-add "$key"
	else
		echo "$key" is exist.
	fi
done

# Auto run neofetch
if [[ -x $(which neofetch) ]] &&
	[[ -z $VIMRUNTIME ]]; then # Not in Vim
	eval "neofetch"
fi

# Auto source venv for python
function cd() {
	builtin cd "$@" || {
		echo "cd Failed"
		exit 1
	}

	if [[ -z "$VIRTUAL_ENV" ]]; then
		## If env folder is found then activate the vitualenv
		if [[ -d ./.venv ]]; then
			# shellcheck source=/dev/null
			source ./.venv/bin/activate
		fi
	else
		## check the current folder belong to earlier VIRTUAL_ENV folder
		# if yes then do nothing
		# else deactivate
		parentdir="$(dirname "$VIRTUAL_ENV")"
		if [[ "$PWD"/ != "$parentdir"/* ]]; then
			deactivate
		fi
	fi
}
