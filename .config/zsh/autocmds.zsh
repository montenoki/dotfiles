#!/usr/bin/env bash

# 启动ssh-agent（如进程数<=20）
proc_name=ssh-agent
proc_count=$(pgrep -f $proc_name | grep -v grep -c)
agent="$(which $proc_name)"
if [[ $proc_count -le 20 ]]; then
	eval "$($agent)"
else
	echo $proc_name is running..
fi

# 添加SSH私钥
typeset -ga keys
keys+=("$HOME/.ssh/id_ed25519")
for key in "${keys[@]}"; do
	if ! ssh-add -l | grep -q "$(ssh-keygen -lf "$key" | cut -d \  -f 2)"; then
		ssh-add "$key"
	else
		echo "$key" is exist.
	fi
done

# 非Vim环境下自动运行neofetch
if [[ -x $(which neofetch) ]] &&
	[[ -z $VIMRUNTIME ]]; then
	eval "neofetch"
fi

# 重写cd命令，自动激活/退出Python虚拟环境
function cd() {
	builtin cd "$@" || {
		echo "cd Failed"
		exit 1
	}

	if [[ -z "$VIRTUAL_ENV" ]]; then
		# 如果当前目录有.venv，则激活环境
		if [[ -d ./.venv ]]; then
			# shellcheck source=/dev/null
			source ./.venv/bin/activate
		fi
	else
		# 如果离开了虚拟环境目录，则退出环境
		parentdir="$(dirname "$VIRTUAL_ENV")"
		if [[ "$PWD"/ != "$parentdir"/* ]]; then
			deactivate
		fi
	fi
}
